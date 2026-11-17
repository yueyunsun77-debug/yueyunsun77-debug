package P_3_3_1_6 {
    public import SEOV_FunctionActions::*;
    action def '自动空调控制' {
        doc /* 分解不等于执行顺序；条件、信息、并行、反馈关系见功能关系.json。兼容LF指标引用不重复实例化。 */
        action '处理用户模式操作' {
            action '判定目标温度边界' : F_LF_008;
            action '更新座舱目标温度' : F_LF_009;
            action '切换自动模式状态' : F_LF_014;
            action '处理AUTO下的AC操作' : F_LF_028;
        }
        action '获取温度与环境信息' {
            action '获取温度与环境信息' : F_LF_010;
        }
        action '协调自动温控请求' {
            action '协调自动温控请求' : F_LF_011;
            action '调节座舱温度' : F_LF_015;
        }
        action '处理AUTO模式请求' {
            action '反馈自动模式状态' : F_LF_012;
        }
        action '更新自动温控运行信息' {
            action '反馈空调运行状态' : F_LF_013;
        }
    }
}
