package ThermalLogicalArchitecture {
    doc /* 逻辑服务分解；part表示逻辑职责，不表示硬件。外部执行服务/信息服务延续原CCU黑盒边界，不能与SL29物理实现边界混同。 */
    part def RequestAndModeManagement;
    part def ThermalInformationProcessing;
    part def HeatingEnableAndProtection;
    part def AutomaticClimateCoordination;
    part def DefrostAndDemistControl;
    part def StateFeedback;
    part def ThermalLogicalControlService {
        part requestAndMode : RequestAndModeManagement;
        part thermalInformation : ThermalInformationProcessing;
        part protectedHeating : HeatingEnableAndProtection;
        part automaticClimate : AutomaticClimateCoordination;
        part windscreenControl : DefrostAndDemistControl;
        part stateFeedback : StateFeedback;
    }
}
