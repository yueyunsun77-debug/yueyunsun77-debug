package P_SC1 {
    public import SEOV_FunctionActions::*;
    action def '串联混动经济性场景' {
        doc /* 分解不等于执行顺序；条件、信息、并行、反馈关系见功能关系.json。兼容LF指标引用不重复实例化。 */
        action '接收驾驶指令' : F_S1_F01;
        action '分析动力需求' : F_S1_F02;
        action '选择运行模式' : F_S1_F03;
        action '控制电驱动能量转换' : F_S1_F04;
        action '判定再生制动请求' : F_S1_F05;
        action '协调再生充电' : F_S1_F06;
        action '协调发动机启动' : F_S1_F07;
        action '调节发动机发电工作点' : F_S1_F08;
        action '管理充电能量收支' : F_S1_F09;
        action '更新运行模式评估信息' : F_S1_F10;
    }
}
