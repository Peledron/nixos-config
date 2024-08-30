{...}: {
  # I will define the htop config using the xdg.configfile method, as the home-manager options confuse me
  xdg.configFile."htop/htoprc".text = ''
    # Beware! This file is rewritten by htop when settings are changed in the interface.
    # The parser is also very primitive, and not human-friendly.
    htop_version=3.3.0
    config_reader_min_version=3
    fields=0 48 17 18 38 39 40 2 46 47 49 1
    hide_kernel_threads=1
    hide_userland_threads=0
    hide_running_in_container=0
    shadow_other_users=0
    show_thread_names=0
    show_program_path=1
    highlight_base_name=0
    highlight_deleted_exe=1
    shadow_distribution_path_prefix=0
    highlight_megabytes=1
    highlight_threads=1
    highlight_changes=0
    highlight_changes_delay_secs=5
    find_comm_in_cmdline=1
    strip_exe_from_cmdline=1
    show_merged_command=0
    header_margin=1
    screen_tabs=1
    detailed_cpu_time=0
    cpu_count_from_one=0
    show_cpu_usage=1
    show_cpu_frequency=0
    show_cpu_temperature=0
    degree_fahrenheit=0
    update_process_names=0
    account_guest_in_cpu_meter=0
    color_scheme=0
    enable_mouse=1
    delay=15
    hide_function_bar=0
    header_layout=two_50_50
    column_meters_0=LeftCPUs4 Memory Swap Zram DiskIO NetworkIO ZFSARC ZFSCARC
    column_meter_modes_0=1 1 1 1 2 2 2 2 2
    column_meters_1=RightCPUs4 LoadAverage Uptime Tasks Systemd SystemdUser DateTime
    column_meter_modes_1=1 2 2 2 2 2 2 2 2
    tree_view=0
    sort_key=39
    tree_sort_key=0
    sort_direction=-1
    tree_sort_direction=1
    tree_view_always_by_pid=0
    all_branches_collapsed=0
    screen:Main=PID USER PRIORITY NICE M_RESIDENT PERCENT_CPU PERCENT_MEM M_VIRT M_SHARE STATE  TIME Command
    .sort_key=M_RESIDENT
    .tree_sort_key=PID
    .tree_view_always_by_pid=0
    .tree_view=0
    .sort_direction=-1
    .tree_sort_direction=1
    .all_branches_collapsed=0
    screen:I/O=PID USER IO_PRIORITY IO_RATE IO_READ_RATE IO_WRITE_RATE PERCENT_SWAP_DELAY PERCENT_IO_DELAY Command
    .sort_key=IO_WRITE_RATE
    .tree_sort_key=PID
    .tree_view_always_by_pid=0
    .tree_view=0
    .sort_direction=-1
    .tree_sort_direction=1
    .all_branches_collapsed=0
  '';
}
