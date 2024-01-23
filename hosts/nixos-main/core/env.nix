{ config, lib, pkgs, ... }:
{
    environment.variables = {
        AMD_VULKAN_ICD="RADV";
        
    };
}
