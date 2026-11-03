// 修改说明：以逻辑功能表达内部职责；原技术信号与需求短ID保留，物理组件映射见Excel。
// 热管理三条需求综合外部环境 BDD
// 覆盖需求：3.3.1.2 空调制热；3.3.1.6 自动空调模式；3.3.1.9 前后风窗除霜/除雾。
// 依据：用户提供的 SysML v2.0 正式规范中 Ports、Connections、Interfaces、Flows and Messages 相关章节。
// 说明：本模型明确端口特征及跨端口的信息流；CAN 内部协议/报文转发实现不在本 BDD 中展开。

package '热管理三条需求外部环境图BDD' {

    // ---------- 端口类型：用户请求 ----------
    port def ThermalRequestPort {
        out attribute heatingRequest : Boolean;
        out attribute autoModeRequest : Boolean;
        out attribute frontDefrostRequest : Boolean;
        out attribute frontDemistRequest : Boolean;
        out attribute targetTemperature : Real;
    }

    // ---------- 端口类型：控制状态反馈 ----------
    port def ThermalStatusPort {
        out attribute heatingActive : Boolean;
        out attribute autoModeActive : Boolean;
        out attribute frontDefrostActive : Boolean;
        out attribute frontDemistActive : Boolean;
    }

    // ---------- 端口类型：整车状态 ----------
    port def VehicleStatePort {
        out attribute highVoltageAvailable : Boolean;
        out attribute vehicleFaultActive : Boolean;
        out attribute stateOfCharge : Real;
    }

    // ---------- 端口类型：传感器数据 ----------
    port def SensorDataPort {
        out attribute cabinTemperature : Real;
        out attribute ambientTemperature : Real;
        out attribute sunLoad : Real;
        out attribute heaterCoreInletTemperature : Real;
        out attribute ptcTemperature : Real;
    }

    // ---------- 端口类型：执行器控制命令 ----------
    port def ActuatorCommandPort {
        out attribute ptcEnable : Boolean;
        out attribute blowerCommand : Real;
        out attribute compressorRequest : Boolean;
        out attribute airDistributionMode : Real;
        out attribute recirculationRequest : Boolean;
    }

    // ---------- 端口类型：对乘员舱/前风窗的抽象控制效果 ----------
    port def CabinEffectPort {
        out attribute cabinHeatingEffect : Boolean;
        out attribute frontWindscreenDefrostEffect : Boolean;
        out attribute frontWindscreenDemistEffect : Boolean;
    }

    // ---------- 接口定义：逐项声明请求特征如何跨接口传递 ----------
    interface def ThermalRequestInterface {
        end source : ThermalRequestPort;
        end target : ~ThermalRequestPort;

        flow source.heatingRequest to target.heatingRequest;
        flow source.autoModeRequest to target.autoModeRequest;
        flow source.frontDefrostRequest to target.frontDefrostRequest;
        flow source.frontDemistRequest to target.frontDemistRequest;
        flow source.targetTemperature to target.targetTemperature;
    }

    // ---------- 接口定义：逐项声明状态反馈特征如何跨接口传递 ----------
    interface def ThermalStatusInterface {
        end source : ThermalStatusPort;
        end target : ~ThermalStatusPort;

        flow source.heatingActive to target.heatingActive;
        flow source.autoModeActive to target.autoModeActive;
        flow source.frontDefrostActive to target.frontDefrostActive;
        flow source.frontDemistActive to target.frontDemistActive;
    }

    // ---------- 接口定义：整车状态输入 ----------
    interface def VehicleStateInterface {
        end source : VehicleStatePort;
        end target : ~VehicleStatePort;

        flow source.highVoltageAvailable to target.highVoltageAvailable;
        flow source.vehicleFaultActive to target.vehicleFaultActive;
        flow source.stateOfCharge to target.stateOfCharge;
    }

    // ---------- 接口定义：环境与温度数据输入 ----------
    interface def SensorDataInterface {
        end source : SensorDataPort;
        end target : ~SensorDataPort;

        flow source.cabinTemperature to target.cabinTemperature;
        flow source.ambientTemperature to target.ambientTemperature;
        flow source.sunLoad to target.sunLoad;
        flow source.heaterCoreInletTemperature to target.heaterCoreInletTemperature;
        flow source.ptcTemperature to target.ptcTemperature;
    }

    // ---------- 接口定义：执行器控制输出 ----------
    interface def ActuatorCommandInterface {
        end source : ActuatorCommandPort;
        end target : ~ActuatorCommandPort;

        flow source.ptcEnable to target.ptcEnable;
        flow source.blowerCommand to target.blowerCommand;
        flow source.compressorRequest to target.compressorRequest;
        flow source.airDistributionMode to target.airDistributionMode;
        flow source.recirculationRequest to target.recirculationRequest;
    }

    // ---------- 接口定义：对乘员舱/前风窗环境的抽象效果 ----------
    interface def CabinEffectInterface {
        end source : CabinEffectPort;
        end target : ~CabinEffectPort;

        flow source.cabinHeatingEffect to target.cabinHeatingEffect;
        flow source.frontWindscreenDefrostEffect to target.frontWindscreenDefrostEffect;
        flow source.frontWindscreenDemistEffect to target.frontWindscreenDemistEffect;
    }

    // ---------- 部件定义及端口 ----------
    part def '热管理逻辑控制服务' {
        port requestIn : ~ThermalRequestPort;
        port statusOut : ThermalStatusPort;
        port vehicleStateIn : ~VehicleStatePort;
        port sensorDataIn : ~SensorDataPort;
        port actuatorCommandOut : ActuatorCommandPort;
        port cabinEffectOut : CabinEffectPort;
    }

    part def 'IVI中控交互系统' {
        port requestOut : ThermalRequestPort;
        port statusIn : ~ThermalStatusPort;
    }

    part def '车载CAN通信网络' {
        port requestIn : ~ThermalRequestPort;
        port requestOut : ThermalRequestPort;
        port statusIn : ~ThermalStatusPort;
        port statusOut : ThermalStatusPort;
    }

    part def '整车状态与电源管理系统' {
        port stateOut : VehicleStatePort;
    }

    part def '温度与环境信息提供服务' {
        port dataOut : SensorDataPort;
    }

    part def '热量与空气调节执行服务' {
        port commandIn : ~ActuatorCommandPort;
    }

    part def '乘员舱与前风窗环境' {
        port effectIn : ~CabinEffectPort;
    }

    // ---------- 外部环境上下文及接口连接 ----------
    part def '热管理控制外部环境' {
        part SYS : '热管理逻辑控制服务';
        part IVI : 'IVI中控交互系统';
        part CAN : '车载CAN通信网络';
        part VEHICLE : '整车状态与电源管理系统';
        part SENSORS : '温度与环境信息提供服务';
        part ACTUATORS : '热量与空气调节执行服务';
        part CABIN_WINDSCREEN : '乘员舱与前风窗环境';

        // 请求路径：IVI -> CAN -> CCU。
        // 每个 interface usage 都把对应的特征流明确到 source/target 端口。
        interface requestIVIToCAN : ThermalRequestInterface
            connect IVI.requestOut to CAN.requestIn;

        interface requestCANToSYS : ThermalRequestInterface
            connect CAN.requestOut to SYS.requestIn;

        // 状态反馈路径：CCU -> CAN -> IVI。
        interface statusSYSOutToCAN : ThermalStatusInterface
            connect SYS.statusOut to CAN.statusIn;

        interface statusCANToIVI : ThermalStatusInterface
            connect CAN.statusOut to IVI.statusIn;

        // 外部状态与传感器输入。
        interface vehicleStateToSYS : VehicleStateInterface
            connect VEHICLE.stateOut to SYS.vehicleStateIn;

        interface sensorDataToSYS : SensorDataInterface
            connect SENSORS.dataOut to SYS.sensorDataIn;

        // 控制命令输出到 HVAC 执行器。
        interface actuatorCommandsToHVAC : ActuatorCommandInterface
            connect SYS.actuatorCommandOut to ACTUATORS.commandIn;

        // 抽象控制效果输出到乘员舱/前风窗环境。
        interface cabinEffectsFromSYS : CabinEffectInterface
            connect SYS.cabinEffectOut to CABIN_WINDSCREEN.effectIn;
    }

    // 外部环境模型根使用
    part THERMAL_EXTERNAL_ENVIRONMENT : '热管理控制外部环境';
}
