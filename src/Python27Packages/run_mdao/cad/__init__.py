"""
Updates the CADAssembly.xml with parameters from testbench_manifest.json.

Functions in this file are always called from the TestBench directory. They must
return from that directory (if there is an exception it does not matter).
"""
import os.path
import logging
import xml.etree.ElementTree as ET

# Maximum time in seconds to wait for each execution.
MAX_WAIT_TIME = 3600 * 2


class TestBenchParameter_to_CadAssembly(object):

    """Updates the CADAssembly.xml with parameters from testbench_manifest.json."""

    # hard-coded names
    local_cadassembly_name = 'CADAssembly.xml'
    modified_cadassembly_name = 'CADAssembly.xml'

    testbench_manifest_json = 'testbench_manifest.json'
    testbench_cadparam_json = 'CADParamTestBenchMapping.json'

    def __init__(self):
        self.logger = logging.getLogger()

    def _parse_json(self, filename):
        import json
        with open(filename, 'r') as f_in:
            return json.load(f_in)

    def populate_cadparam_values(self):
        instanceguid_param_dict = {}
        tbmanifest_dict = self._parse_json(self.testbench_manifest_json)

        def value_to_str(value):
            '''
            Serialize floats better than str does.
            >>> str(1/7.0)
            '0.142857142857'
            >>> repr(1/7.0)
            '0.14285714285714285'
            '''
            if isinstance(value, float):
                return repr(value)
            return str(value)

        self.tbmanifest_params = {parameter['Name']: value_to_str(parameter['Value']) for parameter in tbmanifest_dict.get('Parameters', [])}
        self.logger.debug('testbench_manifest parameters: ' + repr(self.tbmanifest_params))

        if not os.path.isfile(self.testbench_cadparam_json):
            # There are no CAD parameters, even though there are TestBench parameters, so move along.
            self.cadparam_mapping_list = []
        else:
            self.cadparam_mapping_list = self._parse_json(self.testbench_cadparam_json)
            for cadparam in self.cadparam_mapping_list:
                if 'TestBenchParameterName' in cadparam:
                    parameter = self.tbmanifest_params.get(cadparam['TestBenchParameterName'])
                    instance_guid = cadparam.get('ComponentInstanceGUID')
                    if parameter is not None and instance_guid is not None:
                        component_dict = instanceguid_param_dict.setdefault(instance_guid, {})

                        component_dict[cadparam['ComponentCADParameterName']] = parameter
                        self.logger.info('instanceguid_param_dict : {0}'.format(instanceguid_param_dict))

        return instanceguid_param_dict

    def modify_cad_assembly_file(self):
        tree = ET.parse(self.local_cadassembly_name)

        instanceguid_param_dict = self.populate_cadparam_values()
        # find Component under <Assemblies><Assembly>
        for ass_elem in tree.iter(tag='Assembly'):
            for cc_parent in ass_elem.findall('CADComponent'):
                self.logger.debug('Found a parent component in CADAssembly.xml [' + str(cc_parent.attrib['DisplayName']) + ']')
                for cc in cc_parent.findall('CADComponent'):
                    self.logger.debug('Found a component in CADAssembly.xml [' + str(cc.attrib['DisplayName']) + ']')
                    guid = cc.attrib['ComponentID']
                    cadparam_dict_src = instanceguid_param_dict.get(guid)
                    if cadparam_dict_src is not None:
                        # recurse Found Element Component to find CADParameters
                        for pp in cc.findall('ParametricParameters'):
                            for cp in pp.findall('CADParameter'):
                                if cp.get('Name') in cadparam_dict_src:
                                    cp.set('Value', str(cadparam_dict_src[cp.get('Name')]))
                                    self.logger.info('Replaced in XML [%s:%s:%s]\n' % (guid, cp.get('Name'), str(cadparam_dict_src[cp.get('Name')])))

        for cadparam in self.cadparam_mapping_list:
            _id = cadparam.get('_id')
            if _id is not None:
                value = self.tbmanifest_params[cadparam['TestBenchParameterName']]
                node = tree.find(".//*[@_id='{}']".format(_id))
                node.set(cadparam['AttributeName'], value)
                self.logger.info('Replaced in XML [{} {}:{}:{}]\n'.format(node.tag, _id, cadparam['AttributeName'], value))

        tree.write(self.modified_cadassembly_name)
        self.logger.debug('end')
