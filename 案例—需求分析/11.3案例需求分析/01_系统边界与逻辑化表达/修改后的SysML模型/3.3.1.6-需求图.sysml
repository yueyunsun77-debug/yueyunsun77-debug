// 修改说明：以逻辑功能表达内部职责；原技术信号与需求短ID保留，物理组件映射见Excel。
package RequirementModel_02 {
    // 来源：Excel Function list 3.3.1.6；CCU CTS 第67–68页（自动空调控制、自动空调温度控制）。
    // SysML v2 建模：以 requirement def 定义所选需求，以嵌套 requirement usage 表达细化需求。
    requirement def <'3.3.1.6'> AutomaticClimateMode {
        requirement <'3.3.1.6-01'> autoButtonStatus {
            doc /* 处理AUTO请求并反馈状态；AUTO内重复AUTO为invalid，语义待确认 */
        }
        requirement <'3.3.1.6-02'> sensorInputs {
            doc /* 获取室内、室外、日照及供热入口/加热温度信息 */
        }
        requirement <'3.3.1.6-03'> automaticActuatorControl {
            doc /* 协调空气输送、温度/模式/循环调节、制冷与电加热能力 */
        }
        requirement <'3.3.1.6-04'> targetTemperatureAdjustment {
            doc /* LO<16℃、HI>30℃，每次温度调节0.5℃；保持当前模式 */
        }
        requirement <'3.3.1.6-05'> circulationKeepsAuto {
            doc /* 循环操作保持AUTO */
        }
        requirement <'3.3.1.6-06'> modeExitAndTransition {
            doc /* 风量/模式操作退出AUTO但其他项仍自动；前除霜操作进入前除霜 */
        }
        requirement <'3.3.1.6-07'> acButtonBehavior {
            doc /* AC操作关闭制冷，转速请求=0，AUTO反馈Close，其余指定项保持自动 */
        }
    }
}
