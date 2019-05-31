#!/bin/bash

script_run()
{
    # Create group for Docker users 
    groupadd -g 45 docker

}

script_reverse()
{
    # Remove group for Docker users 
    groupdel docker
}
