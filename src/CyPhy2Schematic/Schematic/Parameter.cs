﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Tonka = ISIS.GME.Dsml.CyPhyML.Interfaces;
using TonkaClasses = ISIS.GME.Dsml.CyPhyML.Classes;

namespace CyPhy2Schematic.Schematic
{
    public class Parameter : IComparable<Parameter>
    {
        public virtual string Name { get; set; }
        private string _value;
        public string Value {
            get
            {
                return this._value;
            }
            set
            {
                if (value.StartsWith("."))
                {
                    this._value = "0" + value;
                }
                else
                {
                    this._value = value;
                }
            }
        }
        public string Description { get; set; }

        public virtual int CompareTo(Parameter other)
        {
            return this.Name.CompareTo(other.Name);
        }
    }
}
