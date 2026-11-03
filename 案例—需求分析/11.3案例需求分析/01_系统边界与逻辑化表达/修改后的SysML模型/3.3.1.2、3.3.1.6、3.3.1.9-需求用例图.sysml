// 修改说明：以逻辑功能表达内部职责；原技术信号与需求短ID保留，物理组件映射见Excel。
package '热管理三条需求用例模型' {
    doc /*
        本模型是需求层面的综合用例图，仅展示三条指定需求的主要用例、
        外部参与者和需求追溯关系，不展开内部执行步骤。
        需求编号：3.3.1.2、3.3.1.6、3.3.1.9。
        不添加缺乏需求依据的 include / extend 关系。
    */

    part def '热管理逻辑控制服务';
    part def '驾驶员';
    part def 'IVI中控交互系统';

    requirement def 'REQ_3312_空调制热' {
        subject ccu : '热管理逻辑控制服务';
        doc /*
            对应 Function list 需求 3.3.1.2：空调制热。
            设计依据：CCU Component Technical Specification 6.11.1.3；
            SL29 热管理子系统功能规范 4.6.3.5。
        */
    }
    requirement req3312 : 'REQ_3312_空调制热';

    requirement def 'REQ_3316_自动空调模式' {
        subject ccu : '热管理逻辑控制服务';
        doc /*
            对应 Function list 需求 3.3.1.6：自动空调模式。
            设计依据：CCU Component Technical Specification 6.13.1.3–6.13.1.4；
            SL29 热管理子系统功能规范 4.6.3.4–4.6.3.5。
        */
    }
    requirement req3316 : 'REQ_3316_自动空调模式';

    requirement def 'REQ_3319_前后风窗除霜除雾' {
        subject ccu : '热管理逻辑控制服务';
        doc /*
            对应 Function list 需求 3.3.1.9：前后风窗除霜/除雾。
            设计依据：CCU Component Technical Specification 6.12.1.3–6.12.1.4；
            SL29 热管理子系统功能规范 4.1.3.3。
            注意：现有资料主要支持前除霜和前除雾；后风窗控制逻辑仍待补充。
        */
    }
    requirement req3319 : 'REQ_3319_前后风窗除霜除雾';

    use case def '执行乘员舱制热' {
        subject ccu : '热管理逻辑控制服务';
        actor driver : '驾驶员';
        actor ivi : 'IVI中控交互系统';
        objective {
            doc /* 对应需求 3.3.1.2：接收制热请求，在条件满足时实施受保护的 电加热 加热，并反馈状态。 */
            require req3312;
        }
    }

    use case def '管理自动空调模式' {
        subject ccu : '热管理逻辑控制服务';
        actor driver : '驾驶员';
        actor ivi : 'IVI中控交互系统';
        objective {
            doc /* 对应需求 3.3.1.6：响应 AUTO 请求，根据环境与温度信号协调空调控制，并处理用户操作引起的模式变化。 */
            require req3316;
        }
    }

    use case def '管理风窗除霜与除雾' {
        subject ccu : '热管理逻辑控制服务';
        actor driver : '驾驶员';
        actor ivi : 'IVI中控交互系统';
        objective {
            doc /*
                对应需求 3.3.1.9：管理有设计依据支持的前除霜与前除雾请求。
                后风窗控制细节待补充设计依据。
            */
            require req3319;
        }
    }
}
