// 修改说明：以逻辑功能表达内部职责；原技术信号与需求短ID保留，物理组件映射见Excel。
package RequirementModel_01 {
    private import ScalarValues::*;

    // 来源：Excel Function list 3.3.1.2；CCU CTS 第60页（手动PTC加热控制）；自动模式温控见第67–68页。
    // SysML v2 建模：以 requirement def 定义所选需求，以嵌套 requirement usage 表达细化需求。
    requirement def <'3.3.1.2'> AirConditioningHeating {
        requirement <'3.3.1.2-01'> heatingRequestInput {
            doc /* 接收用户制热请求与目标温度；物理输入路径待确认 */
        }
        requirement <'3.3.1.2-02'> environmentLoadAdaptation {
            doc /* 环境温度与电池热负荷对输出优化方式待明确 */
        }
        requirement <'3.3.1.2-03'> ptcEnableConditions {
            doc /* 空气输送开启、目标温度高于室内、高压可用、整车无故障、SOC>10%全部满足后允许加热 */

            attribute requestHeating : Boolean;
            attribute airflowEnabled : Boolean;
            attribute targetTemperature : Real;
            attribute cabinTemperature : Real;
            attribute highVoltageAvailable : Boolean;
            attribute vehicleFaultActive : Boolean;
            attribute stateOfCharge : Real;
            require constraint { not requestHeating or (airflowEnabled and targetTemperature > cabinTemperature and highVoltageAvailable and not vehicleFaultActive and stateOfCharge > 10) }
        }
        requirement <'3.3.1.2-04'> ptcRelayControl {
            doc /* 按使能条件控制电加热通断；不设计具体继电器硬件 */
        }
        requirement <'3.3.1.2-05'> ptcOvertemperatureProtection {
            doc /* 温度>=XXX℃停止加热，<=XXX℃允许恢复；阈值待标定 */

            attribute protectionWasActive : Boolean;
            attribute heaterTemperature : Real;
            attribute cutOffTemperature : Real;
            attribute recoveryTemperature : Real;
            attribute requestHeating : Boolean;
            require constraint { heaterTemperature < cutOffTemperature or not requestHeating }
            require constraint { not protectionWasActive or heaterTemperature <= recoveryTemperature or not requestHeating }
            // 两个阈值保留为外部待标定参数；不规定未提供的阈值数值或回差。
        }
        requirement <'3.3.1.2-06'> ptcStatusFeedback {
            doc /* 反馈电加热通断、温度、状态及实际/最大功率 */
        }
        requirement <'3.3.1.2-07'> cabinOutdoorTemperatureCheck {
            doc /* 获取室内和室外温度，保留来源采集/通信接口 */
        }
    }
}
