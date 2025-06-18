-- 菜单 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('报修工单', '2000', '1', 'request', 'dorm/request/index', 1, 0, 'C', '0', '0', 'dorm:request:list', '#', 'admin', sysdate(), '', null, '报修工单菜单');

-- 按钮父菜单ID
SELECT @parentId := LAST_INSERT_ID();

-- 按钮 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('报修工单查询', @parentId, '1',  '#', '', 1, 0, 'F', '0', '0', 'dorm:request:query',        '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('报修工单新增', @parentId, '2',  '#', '', 1, 0, 'F', '0', '0', 'dorm:request:add',          '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('报修工单修改', @parentId, '3',  '#', '', 1, 0, 'F', '0', '0', 'dorm:request:edit',         '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('报修工单删除', @parentId, '4',  '#', '', 1, 0, 'F', '0', '0', 'dorm:request:remove',       '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('报修工单导出', @parentId, '5',  '#', '', 1, 0, 'F', '0', '0', 'dorm:request:export',       '#', 'admin', sysdate(), '', null, '');