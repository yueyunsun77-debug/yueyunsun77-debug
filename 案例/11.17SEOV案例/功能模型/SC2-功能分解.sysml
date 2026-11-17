package P_SC2 {
    public import SEOV_FunctionActions::*;
    action def '空调供风辅助电池冷却场景' {
        doc /* 分解不等于执行顺序；条件、信息、并行、反馈关系见功能关系.json。兼容LF指标引用不重复实例化。 */
        action '初始化驾驶循环' : F_S2_F01;
        action '记录静置预冷时长' : F_S2_F02;
        action '控制匀速行驶工况' : F_S2_F03;
        action '处理座舱降温请求' : F_S2_F04;
        action '获取电池温度' : F_S2_F05;
        action '判定电池主动冷却需求' : F_S2_F06;
        action '评估环境空气换热量' : F_S2_F07;
        action '协调座舱与电池冷却能力' : F_S2_F08;
        action '评估主动冷却执行状态' : F_S2_F09;
        action '汇总空气侧换热量' : F_S2_F10;
    }
}
