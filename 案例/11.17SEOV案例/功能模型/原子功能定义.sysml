package SEOV_FunctionActions {
    action def F_LF_001 {
        doc /* 判定电加热使能条件；V=判定；O=电加热使能条件；E=明确加热基础条件是否满足；完整来源路径：11.17SEOV案例 / 3.3.1.2 / 检查电加热使能条件 / LF-001 判定电加热使能条件。 */
        in item inputs_1 { doc /* 空气输送状态；概念级接口。 */ }
        in item inputs_2 { doc /* 目标温度；概念级接口。 */ }
        in item inputs_3 { doc /* 室内温度；概念级接口。 */ }
        in item inputs_4 { doc /* 高压可用状态；概念级接口。 */ }
        out item outputs_1 { doc /* 电加热基础许可；概念级接口。 */ }
    }
    action def F_LF_002 {
        doc /* 判定整车故障下的加热许可；V=判定；O=整车故障下的加热许可；E=阻止故障条件下的不允许加热；完整来源路径：11.17SEOV案例 / 3.3.1.2 / 检查电加热使能条件 / LF-002 判定整车故障下的加热许可。 */
        in item inputs_1 { doc /* 整车故障状态；概念级接口。 */ }
        out item outputs_1 { doc /* 故障约束下的加热许可；概念级接口。 */ }
    }
    action def F_LF_003 {
        doc /* 判定电量约束下的加热许可；V=判定；O=电量约束下的加热许可；E=落实SOC大于10%的使能条件；完整来源路径：11.17SEOV案例 / 3.3.1.2 / 检查电加热使能条件 / LF-003 判定电量约束下的加热许可。 */
        in item inputs_1 { doc /* 动力电池荷电状态；概念级接口。 */ }
        out item outputs_1 { doc /* 电量约束下的加热许可；概念级接口。 */ }
    }
    action def F_LF_004 {
        doc /* 控制电加热通断；V=控制；O=电加热通断；E=按许可及保护状态执行加热请求；完整来源路径：11.17SEOV案例 / 3.3.1.2 / 控制电加热通断 / LF-004 控制电加热通断。 */
        in item inputs_1 { doc /* 制热请求；概念级接口。 */ }
        in item inputs_2 { doc /* 各项加热许可；概念级接口。 */ }
        in item inputs_3 { doc /* 过温保护状态；概念级接口。 */ }
        in item inputs_4 { doc /* 恢复许可；概念级接口。 */ }
        out item outputs_1 { doc /* 电加热通断请求；概念级接口。 */ }
    }
    action def F_LF_005 {
        doc /* 切断过温电加热请求；V=切断；O=过温电加热请求；E=达到待标定上限时停止电加热；完整来源路径：11.17SEOV案例 / 3.3.1.2 / 保护电加热运行 / LF-005 切断过温电加热请求。 */
        in item inputs_1 { doc /* 电加热温度；概念级接口。 */ }
        in item inputs_2 { doc /* 过温上限；概念级接口。 */ }
        out item outputs_1 { doc /* 过温停热请求；概念级接口。 */ }
    }
    action def F_LF_006 {
        doc /* 判定电加热恢复许可；V=判定；O=电加热恢复许可；E=降至待标定恢复阈值后允许重新评估加热；完整来源路径：11.17SEOV案例 / 3.3.1.2 / 保护电加热运行 / LF-006 判定电加热恢复许可。 */
        in item inputs_1 { doc /* 电加热温度；概念级接口。 */ }
        in item inputs_2 { doc /* 恢复阈值；概念级接口。 */ }
        in item inputs_3 { doc /* 其他使能条件；概念级接口。 */ }
        out item outputs_1 { doc /* 恢复加热许可；概念级接口。 */ }
    }
    action def F_LF_007 {
        doc /* 反馈电加热状态；V=反馈；O=电加热状态；E=向外部接口提供加热状态及功率；完整来源路径：11.17SEOV案例 / 3.3.1.2 / 反馈电加热运行信息 / LF-007 反馈电加热状态。 */
        in item inputs_1 { doc /* 电加热通断状态；概念级接口。 */ }
        in item inputs_2 { doc /* 电加热温度；概念级接口。 */ }
        in item inputs_3 { doc /* 工作状态；概念级接口。 */ }
        in item inputs_4 { doc /* 实际功率；概念级接口。 */ }
        in item inputs_5 { doc /* 最大功率；概念级接口。 */ }
        out item outputs_1 { doc /* 电加热状态信息；概念级接口。 */ }
    }
    action def F_LF_008 {
        doc /* 判定目标温度边界；V=判定；O=目标温度边界；E=保留小于16℃为LO及大于30℃为HI的边界；完整来源路径：11.17SEOV案例 / 3.3.1.6 / 处理用户模式操作 / LF-008 判定目标温度边界。 */
        in item inputs_1 { doc /* 用户设定温度；概念级接口。 */ }
        out item outputs_1 { doc /* 目标温度边界状态；概念级接口。 */ }
    }
    action def F_LF_009 {
        doc /* 更新座舱目标温度；V=更新；O=座舱目标温度；E=按原0.5℃步长更新温度设定；完整来源路径：11.17SEOV案例 / 3.3.1.6 / 处理用户模式操作 / LF-009 更新座舱目标温度。 */
        in item inputs_1 { doc /* 温度调节操作；概念级接口。 */ }
        in item inputs_2 { doc /* 当前目标温度；概念级接口。 */ }
        out item outputs_1 { doc /* 更新后的座舱目标温度；概念级接口。 */ }
    }
    action def F_LF_010 {
        doc /* 获取温度与环境信息；V=获取；O=温度与环境信息；E=提供自动温控输入；完整来源路径：11.17SEOV案例 / 3.3.1.6 / 获取温度与环境信息 / LF-010 获取温度与环境信息。 */
        in item inputs_1 { doc /* 室内温度信息；概念级接口。 */ }
        in item inputs_2 { doc /* 室外温度信息；概念级接口。 */ }
        in item inputs_3 { doc /* 日照负荷信息；概念级接口。 */ }
        in item inputs_4 { doc /* 供热入口温度信息；概念级接口。 */ }
        out item outputs_1 { doc /* 温控所需温度与环境信息；概念级接口。 */ }
    }
    action def F_LF_011 {
        doc /* 协调自动温控请求；V=协调；O=自动温控请求；E=协调来源规定的自动调节对象；完整来源路径：11.17SEOV案例 / 3.3.1.6 / 协调自动温控请求 / LF-011 协调自动温控请求。 */
        in item inputs_1 { doc /* 自动模式状态；概念级接口。 */ }
        in item inputs_2 { doc /* 目标温度；概念级接口。 */ }
        in item inputs_3 { doc /* 温度与环境信息；概念级接口。 */ }
        in item inputs_4 { doc /* 可用调节能力；概念级接口。 */ }
        out item outputs_1 { doc /* 送风量请求；概念级接口。 */ }
        out item outputs_2 { doc /* 送风温度请求；概念级接口。 */ }
        out item outputs_3 { doc /* 送风模式请求；概念级接口。 */ }
        out item outputs_4 { doc /* 循环请求；概念级接口。 */ }
        out item outputs_5 { doc /* 制冷能力请求；概念级接口。 */ }
        out item outputs_6 { doc /* 电加热功率请求；概念级接口。 */ }
    }
    action def F_LF_012 {
        doc /* 反馈自动模式状态；V=反馈；O=自动模式状态；E=供IVI显示自动模式状态；完整来源路径：11.17SEOV案例 / 3.3.1.6 / 处理AUTO模式请求 / LF-012 反馈自动模式状态。 */
        in item inputs_1 { doc /* 当前自动模式状态；概念级接口。 */ }
        out item outputs_1 { doc /* 自动模式状态信息；概念级接口。 */ }
    }
    action def F_LF_013 {
        doc /* 反馈空调运行状态；V=反馈；O=空调运行状态；E=供用户识别空调运行状态；完整来源路径：11.17SEOV案例 / 3.3.1.6 / 更新自动温控运行信息 / LF-013 反馈空调运行状态。 */
        in item inputs_1 { doc /* 风量状态；概念级接口。 */ }
        in item inputs_2 { doc /* 温度状态；概念级接口。 */ }
        in item inputs_3 { doc /* 制冷状态；概念级接口。 */ }
        in item inputs_4 { doc /* 循环状态；概念级接口。 */ }
        in item inputs_5 { doc /* 送风模式状态；概念级接口。 */ }
        in item inputs_6 { doc /* 自动模式状态；概念级接口。 */ }
        out item outputs_1 { doc /* 空调运行状态信息；概念级接口。 */ }
    }
    action def F_LF_014 {
        doc /* 切换自动模式状态；V=切换；O=自动模式状态；E=执行不同按键的保持或切换规则；完整来源路径：11.17SEOV案例 / 3.3.1.6 / 处理用户模式操作 / LF-014 切换自动模式状态。 */
        in item inputs_1 { doc /* 当前模式；概念级接口。 */ }
        in item inputs_2 { doc /* 用户温度、循环、风量、模式或前除霜操作；概念级接口。 */ }
        out item outputs_1 { doc /* 更新后的模式状态；概念级接口。 */ }
    }
    action def F_LF_015 {
        doc /* 调节座舱温度；V=调节；O=座舱温度；E=使座舱温度趋近目标；算法及性能窗口待确认；完整来源路径：11.17SEOV案例 / 3.3.1.6 / 协调自动温控请求 / LF-015 调节座舱温度。 */
        in item inputs_1 { doc /* 目标温度；概念级接口。 */ }
        in item inputs_2 { doc /* 实际温度；概念级接口。 */ }
        in item inputs_3 { doc /* 可用温控能力；概念级接口。 */ }
        out item outputs_1 { doc /* 座舱温控请求；概念级接口。 */ }
    }
    action def F_LF_016 {
        doc /* 接收风窗除霜除雾请求；V=接收；O=风窗除霜除雾请求；E=获得外部风窗模式意图；完整来源路径：11.17SEOV案例 / 3.3.1.9 / 接收风窗除霜或除雾请求 / LF-016 接收风窗除霜除雾请求。 */
        in item inputs_1 { doc /* 用户风窗除霜除雾请求；概念级接口。 */ }
        out item outputs_1 { doc /* 已接收的风窗请求；概念级接口。 */ }
    }
    action def F_LF_017 {
        doc /* 调节送风模式；V=调节；O=送风模式；E=请求切换到来源规定的除霜或除雾位置；完整来源路径：11.17SEOV案例 / 3.3.1.9 / 配置风窗模式参数 / LF-017 调节送风模式。 */
        in item inputs_1 { doc /* 风窗模式请求；概念级接口。 */ }
        in item inputs_2 { doc /* 当前送风模式；概念级接口。 */ }
        out item outputs_1 { doc /* 送风模式请求；概念级接口。 */ }
    }
    action def F_LF_018 {
        doc /* 调节送风量；V=调节；O=送风量；E=进入前除霜或除雾时请求最大风量；完整来源路径：11.17SEOV案例 / 3.3.1.9 / 配置风窗模式参数 / LF-018 调节送风量。 */
        in item inputs_1 { doc /* 风窗模式请求；概念级接口。 */ }
        in item inputs_2 { doc /* 可用送风能力；概念级接口。 */ }
        out item outputs_1 { doc /* 送风量请求；概念级接口。 */ }
    }
    action def F_LF_019 {
        doc /* 调节空气循环方式；V=调节；O=空气循环方式；E=请求外循环；90%开度仍为待定；完整来源路径：11.17SEOV案例 / 3.3.1.9 / 配置风窗模式参数 / LF-019 调节空气循环方式。 */
        in item inputs_1 { doc /* 风窗模式请求；概念级接口。 */ }
        in item inputs_2 { doc /* 循环设定；概念级接口。 */ }
        out item outputs_1 { doc /* 空气循环请求；概念级接口。 */ }
    }
    action def F_LF_020 {
        doc /* 调节制冷能力；V=调节；O=制冷能力；E=按来源条件请求制冷除湿；转速接口仅为实现信息；完整来源路径：11.17SEOV案例 / 3.3.1.9 / 确定制冷除湿请求 / LF-020 调节制冷能力。 */
        in item inputs_1 { doc /* 环境温度条件；概念级接口。 */ }
        in item inputs_2 { doc /* 除湿需求；概念级接口。 */ }
        in item inputs_3 { doc /* 制冷许可；概念级接口。 */ }
        in item inputs_4 { doc /* 能力分配；概念级接口。 */ }
        out item outputs_1 { doc /* 制冷能力请求；概念级接口。 */ }
    }
    action def F_LF_021 {
        doc /* 保持座舱温度设定；V=保持；O=座舱温度设定；E=进入风窗模式时保持设定，温度操作按规范处理；完整来源路径：11.17SEOV案例 / 3.3.1.9 / 配置风窗模式参数 / LF-021 保持座舱温度设定。 */
        in item inputs_1 { doc /* 进入模式前的温度设定；概念级接口。 */ }
        in item inputs_2 { doc /* 用户温度操作；概念级接口。 */ }
        out item outputs_1 { doc /* 当前座舱温度设定；概念级接口。 */ }
    }
    action def F_LF_022 {
        doc /* 反馈风窗与空调状态；V=反馈；O=风窗与空调状态；E=将前除霜除雾及相关空调状态提供给IVI；完整来源路径：11.17SEOV案例 / 3.3.1.9 / 反馈风窗运行信息 / LF-022 反馈风窗与空调状态。 */
        in item inputs_1 { doc /* 风窗模式状态；概念级接口。 */ }
        in item inputs_2 { doc /* 风量状态；概念级接口。 */ }
        in item inputs_3 { doc /* 温度状态；概念级接口。 */ }
        in item inputs_4 { doc /* 制冷状态；概念级接口。 */ }
        in item inputs_5 { doc /* 循环状态；概念级接口。 */ }
        out item outputs_1 { doc /* 风窗与空调状态信息；概念级接口。 */ }
    }
    action def F_LF_023 {
        doc /* 仲裁热管理能力请求；V=仲裁；O=热管理能力请求；E=按原SL29优先级分配；XX阈值待确认；完整来源路径：11.17SEOV案例 / 3.3.1.9 / 确定制冷除湿请求 / LF-023 仲裁热管理能力请求。 */
        in item inputs_1 { doc /* 前除霜请求；概念级接口。 */ }
        in item inputs_2 { doc /* 电池冷却请求；概念级接口。 */ }
        in item inputs_3 { doc /* 座舱制冷请求；概念级接口。 */ }
        in item inputs_4 { doc /* 可用能力；概念级接口。 */ }
        out item outputs_1 { doc /* 热管理能力分配；概念级接口。 */ }
    }
    action def F_LF_024 {
        doc /* 判定低电量制冷许可；V=判定；O=低电量制冷许可；E=保留SOC小于10%时前除霜例外；等于10%未规定；完整来源路径：11.17SEOV案例 / 3.3.1.9 / 确定制冷除湿请求 / LF-024 判定低电量制冷许可。 */
        in item inputs_1 { doc /* 动力电池荷电状态；概念级接口。 */ }
        in item inputs_2 { doc /* 前除霜状态；概念级接口。 */ }
        out item outputs_1 { doc /* 低电量条件下的制冷许可；概念级接口。 */ }
    }
    action def F_LF_026 {
        doc /* 控制前风窗除霜除雾模式；V=控制；O=前风窗除霜除雾模式；E=支持有来源依据的前风窗模式；后风窗不外推；完整来源路径：11.17SEOV案例 / 3.3.1.9 / 执行风窗温控请求 / LF-026 控制前风窗除霜除雾模式。 */
        in item inputs_1 { doc /* 前除霜除雾请求；概念级接口。 */ }
        in item inputs_2 { doc /* 当前模式；概念级接口。 */ }
        in item inputs_3 { doc /* 模式退出操作；概念级接口。 */ }
        out item outputs_1 { doc /* 前风窗除霜除雾控制请求；概念级接口。 */ }
    }
    action def F_LF_027 {
        doc /* 获取电加热温度；V=获取；O=电加热温度；E=提供来源规定的50 ms周期温度输入；完整来源路径：11.17SEOV案例 / 3.3.1.2 / 保护电加热运行 / LF-027 获取电加热温度。 */
        in item inputs_1 { doc /* 电加热温度信息；概念级接口。 */ }
        out item outputs_1 { doc /* 电加热温度反馈；概念级接口。 */ }
    }
    action def F_LF_028 {
        doc /* 处理AUTO下的AC操作；V=处理；O=AUTO下的AC操作；E=制冷转速请求为0，其他指定调节项仍自动；完整来源路径：11.17SEOV案例 / 3.3.1.6 / 处理用户模式操作 / LF-028 处理AUTO下的AC操作。 */
        in item inputs_1 { doc /* AUTO运行状态；概念级接口。 */ }
        in item inputs_2 { doc /* AC按键操作；概念级接口。 */ }
        out item outputs_1 { doc /* 制冷关闭请求；概念级接口。 */ }
        out item outputs_2 { doc /* 自动模式Close反馈；概念级接口。 */ }
    }
    action def F_LF_029 {
        doc /* 调节发动机发电工作点；V=调节；O=发动机发电工作点；E=优先维持50%以上负载；最优转速区间未给出；完整来源路径：11.17SEOV案例 / SC1 / S1-F08 调节发动机发电工作点 / LF-029（指标分配引用）。 */
        in item inputs_1 { doc /* 发动机启动状态；概念级接口。 */ }
        in item inputs_2 { doc /* 负载反馈；概念级接口。 */ }
        in item inputs_3 { doc /* 转速反馈；概念级接口。 */ }
        in item inputs_4 { doc /* 发电需求；概念级接口。 */ }
        out item outputs_1 { doc /* 发动机转速目标；概念级接口。 */ }
        out item outputs_2 { doc /* 发动机负载目标；概念级接口。 */ }
    }
    action def F_LF_030 {
        doc /* 记录静置预冷时长；V=记录；O=静置预冷时长；E=满足静置预冷2分钟的场景条件；完整来源路径：11.17SEOV案例 / SC2 / S2-F02 记录静置预冷时长 / LF-030（指标分配引用）。 */
        in item inputs_1 { doc /* 预冷起点；概念级接口。 */ }
        in item inputs_2 { doc /* 经过时间；概念级接口。 */ }
        out item outputs_1 { doc /* 静置预冷完成事件；概念级接口。 */ }
    }
    action def F_LF_031 {
        doc /* 控制匀速行驶工况；V=控制；O=匀速行驶工况；E=执行45 km/h持续20分钟的场景工况；完整来源路径：11.17SEOV案例 / SC2 / S2-F03 控制匀速行驶工况 / LF-031（指标分配引用）。 */
        in item inputs_1 { doc /* 预冷完成事件；概念级接口。 */ }
        in item inputs_2 { doc /* 车速反馈；概念级接口。 */ }
        in item inputs_3 { doc /* 经过时间；概念级接口。 */ }
        out item outputs_1 { doc /* 车辆目标速度；概念级接口。 */ }
        out item outputs_2 { doc /* 行驶阶段完成事件；概念级接口。 */ }
    }
    action def F_LF_032 {
        doc /* 判定电池主动冷却需求；V=判定；O=电池主动冷却需求；E=场景二温度达到或超过35℃时请求冷却；完整来源路径：11.17SEOV案例 / SC2 / S2-F06 判定电池主动冷却需求 / LF-032（指标分配引用）。 */
        in item inputs_1 { doc /* 最高有效电芯控制温度；概念级接口。 */ }
        out item outputs_1 { doc /* 电池主动冷却请求；概念级接口。 */ }
    }
    action def F_S1_F01 {
        doc /* 接收驾驶指令；V=接收；O=驾驶指令；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC1 / S1-F01 接收驾驶指令。 */
        in item inputs_1 { doc /* 加速/制动指令；概念级接口。 */ }
        out item outputs_1 { doc /* 驾驶意图；概念级接口。 */ }
    }
    action def F_S1_F02 {
        doc /* 分析动力需求；V=分析；O=动力需求；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC1 / S1-F02 分析动力需求。 */
        in item inputs_1 { doc /* 驾驶意图、工况；概念级接口。 */ }
        out item outputs_1 { doc /* 驱动/制动需求；概念级接口。 */ }
    }
    action def F_S1_F03 {
        doc /* 选择运行模式；V=选择；O=运行模式；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC1 / S1-F03 选择运行模式。 */
        in item inputs_1 { doc /* 动力需求、能源状态；概念级接口。 */ }
        out item outputs_1 { doc /* 驱动/回收/发电请求；概念级接口。 */ }
    }
    action def F_S1_F04 {
        doc /* 控制电驱动能量转换；V=控制；O=电驱动能量转换；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC1 / S1-F04 控制电驱动能量转换。 */
        in item inputs_1 { doc /* 驱动请求、可用电能；概念级接口。 */ }
        out item outputs_1 { doc /* 驱动力请求与用电反馈；概念级接口。 */ }
    }
    action def F_S1_F05 {
        doc /* 判定再生制动请求；V=判定；O=再生制动请求；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC1 / S1-F05 判定再生制动请求。 */
        in item inputs_1 { doc /* 制动请求、回收可用性；概念级接口。 */ }
        out item outputs_1 { doc /* 再生请求；概念级接口。 */ }
    }
    action def F_S1_F06 {
        doc /* 协调再生充电；V=协调；O=再生充电；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC1 / S1-F06 协调再生充电。 */
        in item inputs_1 { doc /* 再生请求、电池充电状态；概念级接口。 */ }
        out item outputs_1 { doc /* 回收能量与充电请求；概念级接口。 */ }
    }
    action def F_S1_F07 {
        doc /* 协调发动机启动；V=协调；O=发动机启动；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC1 / S1-F07 协调发动机启动。 */
        in item inputs_1 { doc /* 发电请求、启动状态；概念级接口。 */ }
        out item outputs_1 { doc /* 发动机已启动状态；概念级接口。 */ }
    }
    action def F_S1_F08 {
        doc /* 调节发动机发电工作点；V=调节；O=发动机发电工作点；E=优先维持50%以上负载，最优转速区间待确认；完整来源路径：11.17SEOV案例 / SC1 / S1-F08 调节发动机发电工作点。 */
        in item inputs_1 { doc /* 发动机已启动、负载转速反馈；概念级接口。 */ }
        out item outputs_1 { doc /* 发电电能、负载转速目标；概念级接口。 */ }
    }
    action def F_S1_F09 {
        doc /* 管理充电能量收支；V=管理；O=充电能量收支；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC1 / S1-F09 管理充电能量收支。 */
        in item inputs_1 { doc /* 发电/回收电能、电池状态、驱动消耗；概念级接口。 */ }
        out item outputs_1 { doc /* 充电调度与能耗记录；概念级接口。 */ }
    }
    action def F_S1_F10 {
        doc /* 更新运行模式评估信息；V=更新；O=运行模式评估信息；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC1 / S1-F10 更新运行模式评估信息。 */
        in item inputs_1 { doc /* 转速、负载、电池及车辆响应；概念级接口。 */ }
        out item outputs_1 { doc /* 下一步模式评估信息；概念级接口。 */ }
    }
    action def F_S2_F01 {
        doc /* 初始化驾驶循环；V=初始化；O=驾驶循环；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC2 / S2-F01 初始化驾驶循环。 */
        in item inputs_1 { doc /* 仿真开始、空调启动操作；概念级接口。 */ }
        out item outputs_1 { doc /* 静置阶段与座舱降温请求；概念级接口。 */ }
    }
    action def F_S2_F02 {
        doc /* 记录静置预冷时长；V=记录；O=静置预冷时长；E=完成2分钟静置预冷；完整来源路径：11.17SEOV案例 / SC2 / S2-F02 记录静置预冷时长。 */
        in item inputs_1 { doc /* 阶段起点、经过时间；概念级接口。 */ }
        out item outputs_1 { doc /* 静置2分钟完成事件；概念级接口。 */ }
    }
    action def F_S2_F03 {
        doc /* 控制匀速行驶工况；V=控制；O=匀速行驶工况；E=完成45 km/h、20分钟的匀速行驶工况；完整来源路径：11.17SEOV案例 / SC2 / S2-F03 控制匀速行驶工况。 */
        in item inputs_1 { doc /* 预冷完成事件、车速反馈；概念级接口。 */ }
        out item outputs_1 { doc /* 45 km/h行驶20分钟工况；概念级接口。 */ }
    }
    action def F_S2_F04 {
        doc /* 处理座舱降温请求；V=处理；O=座舱降温请求；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC2 / S2-F04 处理座舱降温请求。 */
        in item inputs_1 { doc /* 空调启动、座舱状态；概念级接口。 */ }
        out item outputs_1 { doc /* 座舱制冷需求与响应；概念级接口。 */ }
    }
    action def F_S2_F05 {
        doc /* 获取电池温度；V=获取；O=电池温度；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC2 / S2-F05 获取电池温度。 */
        in item inputs_1 { doc /* 电芯温度快照；概念级接口。 */ }
        out item outputs_1 { doc /* 最高有效电芯温度及有效性；概念级接口。 */ }
    }
    action def F_S2_F06 {
        doc /* 判定电池主动冷却需求；V=判定；O=电池主动冷却需求；E=在电芯控制温度>=35℃时发出主动冷却请求；完整来源路径：11.17SEOV案例 / SC2 / S2-F06 判定电池主动冷却需求。 */
        in item inputs_1 { doc /* 最高有效电芯控制温度；概念级接口。 */ }
        out item outputs_1 { doc /* 主动冷却请求；概念级接口。 */ }
    }
    action def F_S2_F07 {
        doc /* 评估环境空气换热量；V=评估；O=环境空气换热量；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC2 / S2-F07 评估环境空气换热量。 */
        in item inputs_1 { doc /* 电池热节点与前舱局部空气状态；概念级接口。 */ }
        in item inputs_2 { doc /* 独立环境换热边界与有效热导；概念级接口。 */ }
        out item outputs_1 { doc /* 有符号环境换热贡献；概念级接口。 */ }
    }
    action def F_S2_F08 {
        doc /* 协调座舱与电池冷却能力；V=协调；O=座舱与电池冷却能力；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC2 / S2-F08 协调座舱与电池冷却能力。 */
        in item inputs_1 { doc /* 两类冷却需求、可用能力；概念级接口。 */ }
        out item outputs_1 { doc /* 各路径能力分配；概念级接口。 */ }
    }
    action def F_S2_F09 {
        doc /* 评估主动冷却执行状态；V=评估；O=主动冷却执行状态；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC2 / S2-F09 评估主动冷却执行状态。 */
        in item inputs_1 { doc /* 电池主动供风请求及供风可用状态；概念级接口。 */ }
        in item inputs_2 { doc /* 电池入口实际空气温度与流量；概念级接口。 */ }
        in item inputs_3 { doc /* 主动供风有效热导与独立换热边界；概念级接口。 */ }
        out item outputs_1 { doc /* 未请求、不可用、待供风或供风已建立的执行状态；概念级接口。 */ }
        out item outputs_2 { doc /* 主动供风的有符号换热贡献；概念级接口。 */ }
    }
    action def F_S2_F10 {
        doc /* 汇总空气侧换热量；V=汇总；O=空气侧换热量；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC2 / S2-F10 汇总空气侧换热量。 */
        in item inputs_1 { doc /* 环境/主动换热贡献、车辆与电池运行状态；概念级接口。 */ }
        out item outputs_1 { doc /* 电池/座舱热状态反馈；概念级接口。 */ }
    }
    action def F_S3_F01 {
        doc /* 获取座舱目标温度；V=获取；O=座舱目标温度；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC3 / S3-F01 获取座舱目标温度。 */
        in item inputs_1 { doc /* 人员设定或场景目标；概念级接口。 */ }
        out item outputs_1 { doc /* 有效目标温度；概念级接口。 */ }
    }
    action def F_S3_F02 {
        doc /* 获取座舱实际温度；V=获取；O=座舱实际温度；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC3 / S3-F02 获取座舱实际温度。 */
        in item inputs_1 { doc /* 座舱温度信息；概念级接口。 */ }
        out item outputs_1 { doc /* 温度反馈；概念级接口。 */ }
    }
    action def F_S3_F03 {
        doc /* 判定座舱制冷需求；V=判定；O=座舱制冷需求；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC3 / S3-F03 判定座舱制冷需求。 */
        in item inputs_1 { doc /* 目标温度、实测温度；概念级接口。 */ }
        out item outputs_1 { doc /* 座舱制冷需求；概念级接口。 */ }
    }
    action def F_S3_F04 {
        doc /* 调节座舱制冷能力；V=调节；O=座舱制冷能力；E=使座舱温度趋近目标；性能窗口未提供；完整来源路径：11.17SEOV案例 / SC3 / S3-F04 调节座舱制冷能力。 */
        in item inputs_1 { doc /* 分配的制冷能力、制冷需求；概念级接口。 */ }
        out item outputs_1 { doc /* 制冷量调节请求；概念级接口。 */ }
    }
    action def F_S3_F05 {
        doc /* 调节座舱送风量；V=调节；O=座舱送风量；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC3 / S3-F05 调节座舱送风量。 */
        in item inputs_1 { doc /* 制冷请求、空气输送需求；概念级接口。 */ }
        out item outputs_1 { doc /* 座舱空气换热效果；概念级接口。 */ }
    }
    action def F_S3_F06 {
        doc /* 获取电池温度与功率；V=获取；O=电池温度与功率；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC3 / S3-F06 获取电池温度与功率。 */
        in item inputs_1 { doc /* 电池温度、充放电功率；概念级接口。 */ }
        out item outputs_1 { doc /* 有效温度/功率输入；概念级接口。 */ }
    }
    action def F_S3_F07 {
        doc /* 判定电池辅助冷却需求；V=判定；O=电池辅助冷却需求；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC3 / S3-F07 判定电池辅助冷却需求。 */
        in item inputs_1 { doc /* 温度/功率输入；概念级接口。 */ }
        out item outputs_1 { doc /* 辅助冷却需求；概念级接口。 */ }
    }
    action def F_S3_F08 {
        doc /* 计算电池冷却能力需求；V=计算；O=电池冷却能力需求；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC3 / S3-F08 计算电池冷却能力需求。 */
        in item inputs_1 { doc /* 辅助冷却需求、热状态；概念级接口。 */ }
        out item outputs_1 { doc /* 电池冷却能力请求；概念级接口。 */ }
    }
    action def F_S3_F09 {
        doc /* 分配座舱与电池制冷能力；V=分配；O=座舱与电池制冷能力；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC3 / S3-F09 分配座舱与电池制冷能力。 */
        in item inputs_1 { doc /* 座舱/电池请求、可用制冷能力；概念级接口。 */ }
        out item outputs_1 { doc /* 两个功能的能力分配；概念级接口。 */ }
    }
    action def F_S3_F10 {
        doc /* 调节电池液路换热量；V=调节；O=电池液路换热量；E=通过冷却液及Chiller路径移除电池热量；完整来源路径：11.17SEOV案例 / SC3 / S3-F10 调节电池液路换热量。 */
        in item inputs_1 { doc /* 电池分配能力、冷却液状态；概念级接口。 */ }
        out item outputs_1 { doc /* 电池热量交换响应；概念级接口。 */ }
    }
    action def F_S3_F11 {
        doc /* 反馈座舱与电池冷却状态；V=反馈；O=座舱与电池冷却状态；E=未提供，保持空值；完整来源路径：11.17SEOV案例 / SC3 / S3-F11 反馈座舱与电池冷却状态。 */
        in item inputs_1 { doc /* 座舱/电池温度与执行状态；概念级接口。 */ }
        out item outputs_1 { doc /* 需求重新评估信息；概念级接口。 */ }
    }
}
