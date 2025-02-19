.. _fea_perform_analysis:

Performing the Analysis
=======================
Now that we have built a complete Test Bench, we must run it to get our results.
As described in the :ref:`led_performing_circuit_analysis` section of the
:ref:`led_tutorial`, we will be using the **CyPhy Master Interpreter**.

.. figure:: images/IMAGE21.png
   :alt: Solid Modeling Demo

.. tip:: If you wish to start the tutorial here, open the FEA_tutorial_part3.xme.

1. Make sure you are viewing the Simple_Cube_FEA Test Bench.
2. Double-click the **Master Interpreter** and select **okay** at the bottom of
   the new window.
3. In the CAD Options pop-up, unselect both of the preselected AP203 part files
   as they will not be necessary, and click **Okay**.

The results browser should have automatically opened.
In here, you can check the progress of the current tests as well as the results of
previous tests. A complete history of tests stored in the .xme can be found under
the **Test Benches** tab.

4. In the **Active Jobs** tab, right click on the current Test Bench and select
   **Show in explorer**.
5. To view the results of the successful job navigate to
   :menuselection:`Analysis --> Patran_Nastran` and open the
   ``Nastran_mod_3_1_VM_D_iso_1.png`` file.

.. figure:: images/IMAGE22.png
   :alt: Solid Modeling Demo

Here you can see the results of the Nastran Analysis without opening Patran.
If you wish to view the results with Patran, open the ``Nastran_mod.db`` file.
