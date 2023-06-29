{ config, lib, pkgs, inputs, system, ... }:
{   
    imports =  
        (import ./core)
        ++ (import ./system)
    ; 
    system.stateVersion = "22.11"; # initial system state
}
