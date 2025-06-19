-- 菜单 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生离校登记', '2000', '1', 'leave', 'dorm/leave/index', 1, 0, 'C', '0', '0', 'dorm:leave:list', '#', 'admin', sysdate(), '', null, '学生离校登记菜单');

-- 按钮父菜单ID
SELECT @parentId := LAST_INSERT_ID();

-- 按钮 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生离校登记查询', @parentId, '1',  '#', '', 1, 0, 'F', '0', '0', 'dorm:leave:query',        '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生离校登记新增', @parentId, '2',  '#', '', 1, 0, 'F', '0', '0', 'dorm:leave:add',          '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生离校登记修改', @parentId, '3',  '#', '', 1, 0, 'F', '0', '0', 'dorm:leave:edit',         '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生离校登记删除', @parentId, '4',  '#', '', 1, 0, 'F', '0', '0', 'dorm:leave:remove',       '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('学生离校登记导出', @parentId, '5',  '#', '', 1, 0, 'F', '0', '0', 'dorm:leave:export',       '#', 'admin', sysdate(), '', null, '');