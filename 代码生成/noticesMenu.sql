-- 菜单 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('宿舍公告', '2000', '1', 'notices', 'dorm/notices/index', 1, 0, 'C', '0', '0', 'dorm:notices:list', '#', 'admin', sysdate(), '', null, '宿舍公告菜单');

-- 按钮父菜单ID
SELECT @parentId := LAST_INSERT_ID();

-- 按钮 SQL
insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('宿舍公告查询', @parentId, '1',  '#', '', 1, 0, 'F', '0', '0', 'dorm:notices:query',        '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('宿舍公告新增', @parentId, '2',  '#', '', 1, 0, 'F', '0', '0', 'dorm:notices:add',          '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('宿舍公告修改', @parentId, '3',  '#', '', 1, 0, 'F', '0', '0', 'dorm:notices:edit',         '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('宿舍公告删除', @parentId, '4',  '#', '', 1, 0, 'F', '0', '0', 'dorm:notices:remove',       '#', 'admin', sysdate(), '', null, '');

insert into sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
values('宿舍公告导出', @parentId, '5',  '#', '', 1, 0, 'F', '0', '0', 'dorm:notices:export',       '#', 'admin', sysdate(), '', null, '');