package Behaviour_SC1 {
    public import ScalarValues::*;
    public import SEOV_FunctionActions::*;
    doc /* 分析级行为模型。快照动作产生每周期外部输入，布尔分类和未定阈值由适配契约提供。守卫与控制节点真实建模；未实现车辆动力学、执行器算法或源理工具仿真。 */
    action '行为评估流程' {
        action '获取本周期快照' {
            doc /* 功能引用：行为适配/上下文。 */
                    out attribute stopRequested : Boolean;
                    out attribute driveRequested : Boolean;
                    out attribute brakeRequested : Boolean;
                    out attribute regenAvailable : Boolean;
                    out attribute batteryAcceptsCharge : Boolean;
                    out attribute generationRequested : Boolean;
                    out attribute engineRunning : Boolean;
        }
        decide '是否继续评估';
        decide '驾驶意图判断';
        decide '回收可用性判断';
        decide '发电需求判断';
        decide '发动机状态判断';
        decide '启动完成判断';
        fork '并行驱动与发电';
        merge '合并驾驶路径';
        merge '合并发电路径';
        join '汇合能量路径';
        action '接收驾驶指令' : F_S1_F01 {
            doc /* 功能引用：S1-F01。 */

        }
        action '分析动力需求' : F_S1_F02 {
            doc /* 功能引用：S1-F02。 */

        }
        action '选择运行模式' : F_S1_F03 {
            doc /* 功能引用：S1-F03。 */

        }
        action '执行电驱动请求' : F_S1_F04 {
            doc /* 功能引用：S1-F04。 */

        }
        action '判定再生制动请求' : F_S1_F05 {
            doc /* 功能引用：S1-F05。 */

        }
        action '协调再生充电' : F_S1_F06 {
            doc /* 功能引用：S1-F06。 */

        }
        action '调节发电工作点' : F_S1_F08 {
            doc /* 功能引用：S1-F08。 */

        }
        action '管理充电能量收支' : F_S1_F09 {
            doc /* 功能引用：S1-F09。 */

        }
        action '反馈并更新模式评估' : F_S1_F10 {
            doc /* 功能引用：S1-F10。 */

        }
        action '协调发动机启动' : F_S1_F07 {
            doc /* 功能引用：S1-F07。 */
            attribute startCompleted : Boolean;
            doc /* 本节点属性是行为决策所需的分析投影，不重新定义继承的概念级输出端口。 */
        }
        action '记录加速制动冲突' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        action '记录回收不可用' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        action '保持无驱动制动请求' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        action '记录发动机启动未完成' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        action '保持无发电请求' {
            doc /* 功能引用：行为适配/上下文。 */

        }
        first start then '获取本周期快照';
        first '获取本周期快照' then '是否继续评估';
        first '是否继续评估' if '获取本周期快照'.stopRequested then done;
        first '是否继续评估' if not '获取本周期快照'.stopRequested then '接收驾驶指令';
        first '接收驾驶指令' then '分析动力需求';
        first '分析动力需求' then '选择运行模式';
        first '选择运行模式' then '并行驱动与发电';
        first '并行驱动与发电' then '驾驶意图判断';
        first '并行驱动与发电' then '发电需求判断';
        first '驾驶意图判断' if '获取本周期快照'.driveRequested and not '获取本周期快照'.brakeRequested then '执行电驱动请求';
        first '驾驶意图判断' if '获取本周期快照'.brakeRequested and not '获取本周期快照'.driveRequested then '判定再生制动请求';
        first '驾驶意图判断' if '获取本周期快照'.driveRequested and '获取本周期快照'.brakeRequested then '记录加速制动冲突';
        first '驾驶意图判断' if not '获取本周期快照'.driveRequested and not '获取本周期快照'.brakeRequested then '保持无驱动制动请求';
        first '判定再生制动请求' then '回收可用性判断';
        first '回收可用性判断' if '获取本周期快照'.regenAvailable and '获取本周期快照'.batteryAcceptsCharge then '协调再生充电';
        first '回收可用性判断' if not ('获取本周期快照'.regenAvailable and '获取本周期快照'.batteryAcceptsCharge) then '记录回收不可用';
        first '执行电驱动请求' then '合并驾驶路径';
        first '协调再生充电' then '合并驾驶路径';
        first '记录加速制动冲突' then '合并驾驶路径';
        first '记录回收不可用' then '合并驾驶路径';
        first '保持无驱动制动请求' then '合并驾驶路径';
        first '发电需求判断' if '获取本周期快照'.generationRequested then '发动机状态判断';
        first '发电需求判断' if not '获取本周期快照'.generationRequested then '保持无发电请求';
        first '发动机状态判断' if '获取本周期快照'.engineRunning then '调节发电工作点';
        first '发动机状态判断' if not '获取本周期快照'.engineRunning then '协调发动机启动';
        first '协调发动机启动' then '启动完成判断';
        first '启动完成判断' if '协调发动机启动'.startCompleted then '调节发电工作点';
        first '启动完成判断' if not '协调发动机启动'.startCompleted then '记录发动机启动未完成';
        first '调节发电工作点' then '合并发电路径';
        first '记录发动机启动未完成' then '合并发电路径';
        first '保持无发电请求' then '合并发电路径';
        first '合并驾驶路径' then '汇合能量路径';
        first '合并发电路径' then '汇合能量路径';
        first '汇合能量路径' then '管理充电能量收支';
        first '管理充电能量收支' then '反馈并更新模式评估';
        first '反馈并更新模式评估' then '获取本周期快照';
    }
}
