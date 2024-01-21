{ config, lib, pkgs, inputs, system, ... }:
{   
    imports =  
        (import ./core)
        ++ (import ./system)
    ; 
    system.stateVersion = "23.11"; # initial system state
}
