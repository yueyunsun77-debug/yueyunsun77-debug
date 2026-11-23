package SEOV_FunctionActions {
    public import SEOV_ConceptTypes::*;
    action def F_LF_001 {
        doc /* 判定电加热使能条件；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.2 / 检查电加热使能条件 / LF-001 判定电加热使能条件。 */
        in item inputs_1 : C149;
        in item inputs_2 : C144;
        in item inputs_3 : C062;
        in item inputs_4 : C195;
        out item outputs_1 : C117;
    }
    action def F_LF_002 {
        doc /* 判定整车故障下的加热许可；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.2 / 检查电加热使能条件 / LF-002 判定整车故障下的加热许可。 */
        in item inputs_1 : C087;
        out item outputs_1 : C086;
    }
    action def F_LF_003 {
        doc /* 判定电量约束下的加热许可；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.2 / 检查电加热使能条件 / LF-003 判定电量约束下的加热许可。 */
        in item inputs_1 : C037;
        out item outputs_1 : C143;
    }
    action def F_LF_004 {
        doc /* 控制电加热通断；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.2 / 控制电加热通断 / LF-004 控制电加热通断。 */
        in item inputs_1 : C031;
        in item inputs_2 : C057;
        in item inputs_3 : C166;
        in item inputs_4 : C084;
        out item outputs_1 : C124;
    }
    action def F_LF_005 {
        doc /* 切断过温电加热请求；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.2 / 保护电加热运行 / LF-005 切断过温电加热请求。 */
        in item inputs_1 : C118;
        in item inputs_2 : C165;
        out item outputs_1 : C167;
    }
    action def F_LF_006 {
        doc /* 判定电加热恢复许可；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.2 / 保护电加热运行 / LF-006 判定电加热恢复许可。 */
        in item inputs_1 : C118;
        in item inputs_2 : C085;
        in item inputs_3 : C018;
        out item outputs_1 : C083;
    }
    action def F_LF_007 {
        doc /* 反馈电加热状态；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.2 / 反馈电加热运行信息 / LF-007 反馈电加热状态。 */
        in item inputs_1 : C123;
        in item inputs_2 : C118;
        in item inputs_3 : C065;
        in item inputs_4 : C060;
        in item inputs_5 : C091;
        out item outputs_1 : C121;
    }
    action def F_LF_008 {
        doc /* 判定目标温度边界；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 处理用户模式操作 / LF-008 判定目标温度边界。 */
        in item inputs_1 : C113;
        out item outputs_1 : C146;
    }
    action def F_LF_009 {
        doc /* 更新座舱目标温度；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 处理用户模式操作 / LF-009 更新座舱目标温度。 */
        in item inputs_1 : C105;
        in item inputs_2 : C077;
        out item outputs_1 : C089;
    }
    action def F_LF_010 {
        doc /* 获取温度与环境信息；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 获取温度与环境信息 / LF-010 获取温度与环境信息。 */
        in item inputs_1 : C063;
        in item inputs_2 : C064;
        in item inputs_3 : C088;
        in item inputs_4 : C014;
        out item outputs_1 : C106;
    }
    action def F_LF_011 {
        doc /* 协调自动温控请求；层级：组合功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 协调自动温控请求 / LF-011 协调自动温控请求。 */
        in item inputs_1 : C155;
        in item inputs_2 : C144;
        in item inputs_3 : C102;
        in item inputs_4 : C053;
        out item outputs_1 : C175;
        out item outputs_2 : C173;
        out item outputs_3 : C171;
        out item outputs_4 : C082;
        out item outputs_5 : C025;
        out item outputs_6 : C116;
        action '调节自动模式送风量' : F_LF_011_01;
        action '调节自动模式送风温度' : F_LF_011_02;
        action '调节自动模式送风模式' : F_LF_011_03;
        action '调节自动模式空气循环' : F_LF_011_04;
        action '调节自动模式制冷能力' : F_LF_011_05;
        action '调节自动模式电加热功率' : F_LF_011_06;
    }
    action def F_LF_012 {
        doc /* 反馈自动模式状态；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 处理AUTO模式请求 / LF-012 反馈自动模式状态。 */
        in item inputs_1 : C078;
        out item outputs_1 : C156;
    }
    action def F_LF_013 {
        doc /* 反馈空调运行状态；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 更新自动温控运行信息 / LF-013 反馈空调运行状态。 */
        in item inputs_1 : C188;
        in item inputs_2 : C104;
        in item inputs_3 : C023;
        in item inputs_4 : C080;
        in item inputs_5 : C170;
        in item inputs_6 : C155;
        out item outputs_1 : C151;
    }
    action def F_LF_014 {
        doc /* 切换自动模式状态；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 处理用户模式操作 / LF-014 切换自动模式状态。 */
        in item inputs_1 : C076;
        in item inputs_2 : C111;
        out item outputs_1 : C090;
    }
    action def F_LF_015 {
        doc /* 调节座舱温度；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 协调自动温控请求 / LF-015 调节座舱温度。 */
        in item inputs_1 : C144;
        in item inputs_2 : C061;
        in item inputs_3 : C050;
        out item outputs_1 : C073;
    }
    action def F_LF_016 {
        doc /* 接收风窗除霜除雾请求；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.9 / 接收风窗除霜或除雾请求 / LF-016 接收风窗除霜除雾请求。 */
        in item inputs_1 : C114;
        out item outputs_1 : C066;
    }
    action def F_LF_017 {
        doc /* 调节送风模式；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.9 / 配置风窗模式参数 / LF-017 调节送风模式。 */
        in item inputs_1 : C187;
        in item inputs_2 : C079;
        out item outputs_1 : C171;
    }
    action def F_LF_018 {
        doc /* 调节送风量；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.9 / 配置风窗模式参数 / LF-018 调节送风量。 */
        in item inputs_1 : C187;
        in item inputs_2 : C055;
        out item outputs_1 : C175;
    }
    action def F_LF_019 {
        doc /* 调节空气循环方式；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.9 / 配置风窗模式参数 / LF-019 调节空气循环方式。 */
        in item inputs_1 : C187;
        in item inputs_2 : C081;
        out item outputs_1 : C148;
    }
    action def F_LF_020 {
        doc /* 调节制冷能力；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.9 / 确定制冷除湿请求 / LF-020 调节制冷能力。 */
        in item inputs_1 : C110;
        in item inputs_2 : C177;
        in item inputs_3 : C026;
        in item inputs_4 : C153;
        out item outputs_1 : C025;
    }
    action def F_LF_021 {
        doc /* 保持座舱温度设定；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.9 / 配置风窗模式参数 / LF-021 保持座舱温度设定。 */
        in item inputs_1 : C168;
        in item inputs_2 : C112;
        out item outputs_1 : C075;
    }
    action def F_LF_022 {
        doc /* 反馈风窗与空调状态；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.9 / 反馈风窗运行信息 / LF-022 反馈风窗与空调状态。 */
        in item inputs_1 : C186;
        in item inputs_2 : C188;
        in item inputs_3 : C104;
        in item inputs_4 : C023;
        in item inputs_5 : C080;
        out item outputs_1 : C185;
    }
    action def F_LF_023 {
        doc /* 仲裁热管理能力请求；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.9 / 确定制冷除湿请求 / LF-023 仲裁热管理能力请求。 */
        in item inputs_1 : C033;
        in item inputs_2 : C134;
        in item inputs_3 : C069;
        in item inputs_4 : C052;
        out item outputs_1 : C107;
    }
    action def F_LF_024 {
        doc /* 判定低电量制冷许可；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.9 / 确定制冷除湿请求 / LF-024 判定低电量制冷许可。 */
        in item inputs_1 : C037;
        in item inputs_2 : C032;
        out item outputs_1 : C013;
    }
    action def F_LF_026 {
        doc /* 控制前风窗除霜除雾模式；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.9 / 执行风窗温控请求 / LF-026 控制前风窗除霜除雾模式。 */
        in item inputs_1 : C034;
        in item inputs_2 : C076;
        in item inputs_3 : C100;
        out item outputs_1 : C035;
    }
    action def F_LF_027 {
        doc /* 获取电加热温度；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.2 / 保护电加热运行 / LF-027 获取电加热温度。 */
        in item inputs_1 : C119;
        out item outputs_1 : C120;
    }
    action def F_LF_028 {
        doc /* 处理AUTO下的AC操作；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 处理用户模式操作 / LF-028 处理AUTO下的AC操作。 */
        in item inputs_1 : C003;
        in item inputs_2 : C002;
        out item outputs_1 : C022;
        out item outputs_2 : C154;
    }
    action def F_LF_029 {
        doc /* 调节发动机发电工作点；层级：兼容ID引用；来源：11.23SEOV案例_优化版 / SC1 / S1-F08 调节发动机发电工作点 / LF-029（指标分配引用）。 */
        in item inputs_1 : C039;
        in item inputs_2 : C158;
        in item inputs_3 : C162;
        in item inputs_4 : C047;
        out item outputs_1 : C043;
        out item outputs_2 : C042;
    }
    action def F_LF_030 {
        doc /* 记录静置预冷时长；层级：兼容ID引用；来源：11.23SEOV案例_优化版 / SC2 / S2-F02 记录静置预冷时长 / LF-030（指标分配引用）。 */
        in item inputs_1 : C184;
        in item inputs_2 : C152;
        out item outputs_1 : C181;
    }
    action def F_LF_031 {
        doc /* 控制匀速行驶工况；层级：兼容ID引用；来源：11.23SEOV案例_优化版 / SC2 / S2-F03 控制匀速行驶工况 / LF-031（指标分配引用）。 */
        in item inputs_1 : C182;
        in item inputs_2 : C160;
        in item inputs_3 : C152;
        out item outputs_1 : C159;
        out item outputs_2 : C157;
    }
    action def F_LF_032 {
        doc /* 判定电池主动冷却需求；层级：兼容ID引用；来源：11.23SEOV案例_优化版 / SC2 / S2-F06 判定电池主动冷却需求 / LF-032（指标分配引用）。 */
        in item inputs_1 : C092;
        out item outputs_1 : C128;
    }
    action def F_S1_F01 {
        doc /* 接收驾驶指令；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC1 / S1-F01 接收驾驶指令。 */
        in item inputs_1 : C036;
        out item outputs_1 : C193;
    }
    action def F_S1_F02 {
        doc /* 分析动力需求；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC1 / S1-F02 分析动力需求。 */
        in item inputs_1 : C194;
        out item outputs_1 : C189;
    }
    action def F_S1_F03 {
        doc /* 选择运行模式；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC1 / S1-F03 选择运行模式。 */
        in item inputs_1 : C038;
        out item outputs_1 : C190;
    }
    action def F_S1_F04 {
        doc /* 控制电驱动能量转换；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC1 / S1-F04 控制电驱动能量转换。 */
        in item inputs_1 : C192;
        out item outputs_1 : C191;
    }
    action def F_S1_F05 {
        doc /* 判定再生制动请求；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC1 / S1-F05 判定再生制动请求。 */
        in item inputs_1 : C030;
        out item outputs_1 : C019;
    }
    action def F_S1_F06 {
        doc /* 协调再生充电；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC1 / S1-F06 协调再生充电。 */
        in item inputs_1 : C020;
        out item outputs_1 : C058;
    }
    action def F_S1_F07 {
        doc /* 协调发动机启动；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC1 / S1-F07 协调发动机启动。 */
        in item inputs_1 : C046;
        out item outputs_1 : C041;
    }
    action def F_S1_F08 {
        doc /* 调节发动机发电工作点；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC1 / S1-F08 调节发动机发电工作点。 */
        in item inputs_1 : C040;
        out item outputs_1 : C045;
    }
    action def F_S1_F09 {
        doc /* 管理充电能量收支；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC1 / S1-F09 管理充电能量收支。 */
        in item inputs_1 : C044;
        out item outputs_1 : C017;
    }
    action def F_S1_F10 {
        doc /* 更新运行模式评估信息；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC1 / S1-F10 更新运行模式评估信息。 */
        in item inputs_1 : C161;
        out item outputs_1 : C004;
    }
    action def F_S2_F01 {
        doc /* 初始化驾驶循环；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC2 / S2-F01 初始化驾驶循环。 */
        in item inputs_1 : C012;
        out item outputs_1 : C180;
    }
    action def F_S2_F02 {
        doc /* 记录静置预冷时长；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC2 / S2-F02 记录静置预冷时长。 */
        in item inputs_1 : C176;
        out item outputs_1 : C179;
    }
    action def F_S2_F03 {
        doc /* 控制匀速行驶工况；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC2 / S2-F03 控制匀速行驶工况。 */
        in item inputs_1 : C183;
        out item outputs_1 : C001;
    }
    action def F_S2_F04 {
        doc /* 处理座舱降温请求；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC2 / S2-F04 处理座舱降温请求。 */
        in item inputs_1 : C150;
        out item outputs_1 : C071;
    }
    action def F_S2_F05 {
        doc /* 获取电池温度；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC2 / S2-F05 获取电池温度。 */
        in item inputs_1 : C142;
        out item outputs_1 : C093;
    }
    action def F_S2_F06 {
        doc /* 判定电池主动冷却需求；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC2 / S2-F06 判定电池主动冷却需求。 */
        in item inputs_1 : C092;
        out item outputs_1 : C010;
    }
    action def F_S2_F07 {
        doc /* 评估环境空气换热量；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC2 / S2-F07 评估环境空气换热量。 */
        in item inputs_1 : C139;
        in item inputs_2 : C108;
        out item outputs_1 : C098;
    }
    action def F_S2_F08 {
        doc /* 协调座舱与电池冷却能力；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC2 / S2-F08 协调座舱与电池冷却能力。 */
        in item inputs_1 : C006;
        out item outputs_1 : C056;
    }
    action def F_S2_F09 {
        doc /* 评估主动供风响应；层级：组合功能；来源：11.23SEOV案例_优化版 / SC2 / S2-F09 评估主动冷却执行状态。 */
        in item inputs_1 : C127;
        in item inputs_2 : C132;
        in item inputs_3 : C008;
        out item outputs_1 : C099;
        out item outputs_2 : C009;
        action '获取电池入口实际供风条件' : F_S2_F09_01;
        action '判定电池实际供风状态' : F_S2_F09_02;
        action '计算主动供风换热量' : F_S2_F09_03;
    }
    action def F_S2_F10 {
        doc /* 汇总空气侧换热量；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC2 / S2-F10 汇总空气侧换热量。 */
        in item inputs_1 : C109;
        out item outputs_1 : C125;
    }
    action def F_S3_F01 {
        doc /* 获取座舱目标温度；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC3 / S3-F01 获取座舱目标温度。 */
        in item inputs_1 : C011;
        out item outputs_1 : C097;
    }
    action def F_S3_F02 {
        doc /* 获取座舱实际温度；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC3 / S3-F02 获取座舱实际温度。 */
        in item inputs_1 : C072;
        out item outputs_1 : C103;
    }
    action def F_S3_F03 {
        doc /* 判定座舱制冷需求；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC3 / S3-F03 判定座舱制冷需求。 */
        in item inputs_1 : C145;
        out item outputs_1 : C070;
    }
    action def F_S3_F04 {
        doc /* 调节座舱制冷能力；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC3 / S3-F04 调节座舱制冷能力。 */
        in item inputs_1 : C021;
        out item outputs_1 : C029;
    }
    action def F_S3_F05 {
        doc /* 调节座舱送风量；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC3 / S3-F05 调节座舱送风量。 */
        in item inputs_1 : C027;
        out item outputs_1 : C074;
    }
    action def F_S3_F06 {
        doc /* 获取电池温度与功率；层级：组合功能；来源：11.23SEOV案例_优化版 / SC3 / S3-F06 获取电池温度与功率。 */
        in item inputs_1 : C137;
        out item outputs_1 : C094;
        action '获取电池控制温度' : F_S3_F06_01;
        action '获取电池充放电功率' : F_S3_F06_02;
    }
    action def F_S3_F07 {
        doc /* 判定电池辅助冷却需求；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC3 / S3-F07 判定电池辅助冷却需求。 */
        in item inputs_1 : C101;
        out item outputs_1 : C163;
    }
    action def F_S3_F08 {
        doc /* 计算电池冷却能力需求；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC3 / S3-F08 计算电池冷却能力需求。 */
        in item inputs_1 : C164;
        out item outputs_1 : C133;
    }
    action def F_S3_F09 {
        doc /* 分配座舱与电池制冷能力；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC3 / S3-F09 分配座舱与电池制冷能力。 */
        in item inputs_1 : C068;
        out item outputs_1 : C005;
    }
    action def F_S3_F10 {
        doc /* 调节电池液路换热量；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC3 / S3-F10 调节电池液路换热量。 */
        in item inputs_1 : C135;
        out item outputs_1 : C140;
    }
    action def F_S3_F11 {
        doc /* 反馈座舱与电池冷却状态；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC3 / S3-F11 反馈座舱与电池冷却状态。 */
        in item inputs_1 : C067;
        out item outputs_1 : C178;
    }
    action def F_LF_011_01 {
        doc /* 调节自动模式送风量；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 协调自动温控请求 / LF-011 协调自动温控请求 / LF-011-01 调节自动模式送风量。 */
        in item inputs_1 : C175;
        in item inputs_2 : C051;
        out item outputs_1 : C174;
    }
    action def F_LF_011_02 {
        doc /* 调节自动模式送风温度；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 协调自动温控请求 / LF-011 协调自动温控请求 / LF-011-02 调节自动模式送风温度。 */
        in item inputs_1 : C173;
        in item inputs_2 : C049;
        out item outputs_1 : C172;
    }
    action def F_LF_011_03 {
        doc /* 调节自动模式送风模式；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 协调自动温控请求 / LF-011 协调自动温控请求 / LF-011-03 调节自动模式送风模式。 */
        in item inputs_1 : C171;
        in item inputs_2 : C054;
        out item outputs_1 : C169;
    }
    action def F_LF_011_04 {
        doc /* 调节自动模式空气循环；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 协调自动温控请求 / LF-011 协调自动温控请求 / LF-011-04 调节自动模式空气循环。 */
        in item inputs_1 : C082;
        in item inputs_2 : C048;
        out item outputs_1 : C147;
    }
    action def F_LF_011_05 {
        doc /* 调节自动模式制冷能力；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 协调自动温控请求 / LF-011 协调自动温控请求 / LF-011-05 调节自动模式制冷能力。 */
        in item inputs_1 : C025;
        in item inputs_2 : C028;
        out item outputs_1 : C024;
    }
    action def F_LF_011_06 {
        doc /* 调节自动模式电加热功率；层级：叶级功能；来源：11.23SEOV案例_优化版 / 3.3.1.6 / 协调自动温控请求 / LF-011 协调自动温控请求 / LF-011-06 调节自动模式电加热功率。 */
        in item inputs_1 : C116;
        in item inputs_2 : C122;
        out item outputs_1 : C115;
    }
    action def F_S2_F09_01 {
        doc /* 获取电池入口实际供风条件；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC2 / S2-F09 评估主动冷却执行状态 / S2-F09-01 获取电池入口实际供风条件。 */
        in item inputs_1 : C059;
        out item outputs_1 : C131;
        out item outputs_2 : C130;
        out item outputs_3 : C015;
    }
    action def F_S2_F09_02 {
        doc /* 判定电池实际供风状态；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC2 / S2-F09 评估主动冷却执行状态 / S2-F09-02 判定电池实际供风状态。 */
        in item inputs_1 : C126;
        in item inputs_2 : C016;
        in item inputs_3 : C130;
        in item inputs_4 : C015;
        out item outputs_1 : C136;
    }
    action def F_S2_F09_03 {
        doc /* 计算主动供风换热量；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC2 / S2-F09 评估主动冷却执行状态 / S2-F09-03 计算主动供风换热量。 */
        in item inputs_1 : C141;
        in item inputs_2 : C131;
        in item inputs_3 : C007;
        in item inputs_4 : C136;
        out item outputs_1 : C009;
    }
    action def F_S3_F06_01 {
        doc /* 获取电池控制温度；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC3 / S3-F06 获取电池温度与功率 / S3-F06-01 获取电池控制温度。 */
        in item inputs_1 : C138;
        out item outputs_1 : C096;
    }
    action def F_S3_F06_02 {
        doc /* 获取电池充放电功率；层级：叶级功能；来源：11.23SEOV案例_优化版 / SC3 / S3-F06 获取电池温度与功率 / S3-F06-02 获取电池充放电功率。 */
        in item inputs_1 : C129;
        out item outputs_1 : C095;
    }
}
