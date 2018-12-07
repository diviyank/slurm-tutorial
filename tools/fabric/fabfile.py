#!/usr/bin/env python

from fabric.api import *
import getpass
import sys
# from fabric import Connection
# env.gateway = 'dkalaina@titanic'
# env.gateway = [, '']
# import argparse

# parser = argparse.ArgumentParser(description='Parser')
# parser.add_argument("cmd", type=str, help='cmd to run')
# args = parser.parse_args()
def connect(host):

    return Connection(host, gateway=Connection('dkalaina@titanic', gateway=Connection('dkalaina@ssh.saclay.inria.fr')))


env.hosts = ['citronelle']  # Liste des noeuds.
env.password = getpass.getpass('sudo password: ')

@task()
def sudo_cmd(cmd):
    # sudo('/usr/bin/python' + str(python_version) + ' -m pip install keras')
    # sudo('/usr/bin/python2 -m pip install keras')
    sudo(cmd)
