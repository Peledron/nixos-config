{ config, lib, pkgs, inputs, system, ... }:
{   
    imports =  
        (import ./core)
        ++ (import ./system)
    ; 
}
