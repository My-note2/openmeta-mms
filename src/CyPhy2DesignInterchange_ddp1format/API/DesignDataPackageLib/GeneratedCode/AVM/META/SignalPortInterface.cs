﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool
//     Changes to this file will be lost if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------
namespace AVM.META
{
	using System;
	using System.Collections.Generic;
	using System.Linq;
	using System.Text;

	public class SignalPortInterface : Interface
	{
		public virtual BehaviorModelSignalPortTypeEnum SignalPortType
		{
			get;
			set;
		}

		public virtual DirectionEnum Directionality
		{
			get;
			set;
		}

		public virtual BehaviorModelSignalPortTimingSemanticsEnum? TimingSemantics
		{
			get;
			set;
		}

		public virtual Double? DiscreteTimeStep
		{
			get;
			set;
		}

		public virtual Double? DiscreteTimePhase
		{
			get;
			set;
		}

	}
}

