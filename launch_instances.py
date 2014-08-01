#!/usr/bin/env python
# -*- coding:utf-8 -*-

"""This is a OpenStack API to start the VM script!"""

__version__ = '0.1'
__author__ = [
    'Longgeek <longgeek@gmail.com>',
]

import urllib
import httplib
import json
import time
import os
from urlparse import urlparse

## Arguments:
## Make sure that url is set to the actual hostname/IP address,
## Make sure that user is set to your actual username.
## Your password
## Your tenant name

os.system('clear')
print '------------------ www.thstack.com ------------------\n\n'
print '#####################################################'
print '### Please enter the keystone service IP address: ###'
print '#####################################################\n'

while True:
    auth_ip = raw_input('\n!Now -> Input: ')
    if auth_ip == '':
        continue
    else:
        break

print '\n#####################################################'
print '###   Please enter the nova service IP address:   ###'
print '#####################################################\n'

while True:
    nova_ip = raw_input('\n!Now -> Input: ')
    if nova_ip == '':
        continue
    else:
        break

print '\n#####################################################'
print '###  Please enter the neutron service IP address: ###'
print '#####################################################\n'

while True:
    neutron_ip = raw_input('\n!Now -> Input: ')
    if auth_ip == '':
        continue
    else:
        break

print '\n#####################################################'
print '###          Please enter the username:           ###'
print '#####################################################\n'

while True:
    user_name = raw_input('\n!Now -> Input: ')
    if user_name == '':
        continue
    else:
        break

print '\n#####################################################'
print '###        Please enter the user password:        ###'
print '#####################################################\n'

while True:
    user_password = raw_input('\n!Now -> Input: ')
    if user_password == '':
        continue
    else:
        break

print '\n#####################################################'
print '###       Please enter the user tenant name:      ###'
print '#####################################################\n'

while True:
    user_tenant_name = raw_input('\n!Now -> Input: ')
    if user_tenant_name == '':
        continue
    else:
        break

auth_url = '%s:5000' % auth_ip
nova_url = '%s:8774' % nova_ip
neutron_url = '%s:9696' % neutron_ip

server_params = urllib.urlencode({})
token_headers = {'Content-Type': 'application/json'}
token_params = '{"auth":{"passwordCredentials":{"username": "'+user_name+'", "password":"'+user_password+'"}, "tenantName":"'+user_tenant_name+'"}}'

## HTTP connection
auth_conn = httplib.HTTPConnection(auth_url, timeout=3)
nova_conn = httplib.HTTPConnection(nova_url, timeout=3)
neutron_conn = httplib.HTTPConnection(neutron_url, timeout=3)

def gen_token():
    ## Get token
    auth_conn.request('POST', '/v2.0/tokens', token_params, token_headers)
    token_response = auth_conn.getresponse()
    token_read = token_response.read()
    token_data = json.loads(token_read)
    api_token = token_data['access']['token']['id']
    return api_token


def get_tenant_id(api_token):
    ## Get tenant id
    token_params = urllib.urlencode({})
    tenant_token_headers = {'User-Agent': 'python-keystoneclient', 'X-Auth-Token': api_token}

    auth_conn.request('GET', '/v2.0/tenants', token_params, tenant_token_headers)
    tenant_response = auth_conn.getresponse()
    tenant_read = tenant_response.read()
    tenant_datas = json.loads(tenant_read)

    for i in range(len(tenant_datas['tenants'])):
        if tenant_datas['tenants'][i]['name'] == user_name:
            user_tenant_id = tenant_datas['tenants'][i]['id']
    return user_tenant_id

def get_images(api_token, user_tenant_id):
    ## Get images
    server_headers = {'X-Auth-Token': api_token, 'Content-Type': 'application/json'}
    nova_conn.request('GET', '/v2/%s/images' % user_tenant_id, server_params, server_headers)
    image_responses = nova_conn.getresponse()
    image_read = image_responses.read()
    image_datas = json.loads(image_read)

    ## Images List
    images_links = []
    images_names = []
    for i in range(len(image_datas['images'])):
        images_links.append(image_datas['images'][i]['links'][0]['href'])
        images_names.append(image_datas['images'][i]['name'])

    if len(images_links) == 0:
        print 'Not images for this cloud!'
        exit(1)
    return (images_names, images_links)

def get_flavors(api_token, user_tenant_id):
    ## Get Flavor
    server_headers = {'X-Auth-Token': api_token, 'Content-Type': 'application/json'}
    nova_conn.request('GET', '/v2/%s/flavors' % user_tenant_id, server_params, server_headers)
    flavor_responses = nova_conn.getresponse()
    flavor_read = flavor_responses.read()
    flavor_datas = json.loads(flavor_read)

    ## Flavor List
    flavors_links = []
    flavors_names = []
    for i in range(len(flavor_datas['flavors'])):
       flavors_links.append(flavor_datas['flavors'][i]['links'][0]['href'])
       flavors_names.append(flavor_datas['flavors'][i]['name'])
    return(flavors_names, flavors_links)

def get_networks(api_token):
    ## Get Networking
    server_headers = {'X-Auth-Token': api_token, 'Content-Type': 'application/json'}
    neutron_conn.request('GET', '/v2.0/networks', server_params, server_headers)
    network_responses = neutron_conn.getresponse()
    network_read = network_responses.read()
    network_datas = json.loads(network_read)

    ## Network List
    networks_lists = []
    networks_names = []
    for i in range(len(network_datas['networks'])):
        if network_datas['networks'][i]['router:external']:
            continue
        networks_lists.append(network_datas['networks'][i]['id'])
        networks_names.append(network_datas['networks'][i]['name'])

    if len(networks_lists) == 0:
        print 'Not Network for this tenant!'
        exit(1)
    return (networks_names, networks_lists)

def get_keypairs(api_token, user_tenant_id):
    ## Get keypairs
    server_headers = {'X-Auth-Token': api_token, 'Content-Type': 'application/json'}
    nova_conn.request('GET', '/v2/%s/os-keypairs' % user_tenant_id, server_params, server_headers)
    keypair_responses = nova_conn.getresponse()
    keypair_read = keypair_responses.read()
    keypair_datas = json.loads(keypair_read)

    #print keypair_datas['keypairs'][0]['keypair']['name']
    # Keypairs List
    keypairs_list = []
    for i in range(len(keypair_datas['keypairs'])):
        keypairs_list.append(keypair_datas['keypairs'][i]['keypair']['name'])

    if len(keypairs_list) == 0:
        print 'Not Keypairs for this cloud!'
        exit('1')
    return keypairs_list

def create_server(api_token, user_tenant_id):
    def_get_images = get_images(api_token, user_tenant_id)
    def_get_flavors = get_flavors(api_token, user_tenant_id)
    def_get_keypairs = get_keypairs(api_token, user_tenant_id)
    def_get_networks = get_networks(api_token)
    keypairs_list = get_keypairs(api_token, user_tenant_id)

    images_names = def_get_images[0]
    images_links = def_get_images[1]
    flavors_names = def_get_flavors[0]
    flavors_links = def_get_flavors[1]
    networks_names = def_get_networks[0]
    networks_lists = def_get_networks[1]

    print '\n################################################'
    print '###    Please enter to start the VM name:    ###'
    print '################################################\n'

    while True:
        vm_name = raw_input('\n!Now -> Input: ')
        if vm_name == '':
            continue
        else:
            break

    print '\n################################################'
    print '###     You have the following images:       ###'
    print '################################################\n'

    for image in range(len(images_names)):
        print '    ', '%s.' % image, images_names[image]
    while True:
        select_image = raw_input('\n!Now -> Select Number: ')
        if select_image == '':
            continue
        elif select_image not in str(range(len(images_names))):
            continue
        else:
            break

    print '\n################################################'
    print '###     You have the following keypairs:     ###'
    print '################################################\n'

    for keypair in range(len(keypairs_list)):
        print '    ', '%s.' % keypair, keypairs_list[keypair]
    while True:
        select_keypair = raw_input('\n!Now -> Select Number: ')
        if select_keypair == '':
            continue
        elif select_keypair not in str(range(len(keypairs_list))):
            continue
        else:
            break

    print '\n################################################'
    print '###     You have the following flavors:      ###'
    print '################################################\n'

    for flavor in range(len(flavors_names)):
        print '    ', '%s.' % flavor, flavors_names[flavor]
    while True:
        select_flavor = raw_input('\n!Now -> Select Number: ')
        if select_flavor == '':
            continue
        elif select_flavor not in str(range(len(flavors_names))):
            continue
        else:
            break

    print '\n#################################################'
    print '###     You have the following networks:      ###'
    print '#################################################\n'

    for network in range(len(networks_names)):
        print '    ', '%s.' % network, networks_names[network]
    while True:
        select_network = raw_input('\n!Now -> Select Number: ')
        if select_network == '':
            continue
        elif select_network not in str(range(len(networks_names))):
            continue
        else:
            break

    print '\n#################################################'
    print '###  Please enter your VM root user password: ###'
    print '#################################################\n'

    while True:
        vm_password = raw_input('\n!Now -> Input: ')
        if vm_password == '':
            continue
        else:
            break

    print '\n#################################################'
    print '###        Please enter the VM count:         ###'
    print '#################################################\n'

    while True:
        vm_count = raw_input('\n!Now -> Input: ')
        if vm_count == '':
            continue
        elif not vm_count.isdigit():
            continue
        elif vm_count == '0':
            continue
        else:
            break
    server_name = vm_name
    server_keypairs = keypairs_list[int(select_keypair)]
    server_imageRef = images_links[int(select_image)]
    server_flavorRef = flavors_links[int(select_flavor)]
    server_adminPass = vm_password
    server_networks = networks_lists[int(select_network)]
    server_metadata = ''
    server_max_count = vm_count
    server_min_count = 1
    #server_personality = [{'path': '', 'contents': ''}]

    define_server = {'server': {'name': server_name, 'key_name': server_keypairs, 'networks': [{'uuid': server_networks}], 'adminPass': server_adminPass, 'OS-DCF:diskConfig': 'AUTO', 'max_count': server_max_count, 'min_count': server_min_count, 'return_reservation_id': 'True', 'imageRef': server_imageRef, 'flavorRef': server_flavorRef, 'metadata': server_metadata}}

    # HTTP connection
    server_headers = {'X-Auth-Token': api_token, 'Content-Type': 'application/json'}
    nova_conn.request("POST", "/v2/%s/servers" % user_tenant_id, json.dumps(define_server), server_headers)
    server_response = nova_conn.getresponse()
    server_read = server_response.read()
    server_data = json.loads(server_read)
    #print json.dumps(dd3, indent=2)

    # Create the user env file for keystone authentication
    env_file = open('%s/user-env.sh' % os.path.expanduser('~'), 'w')
    env_file.write('#!/bin/bash\n')
    env_file.write('export OS_USERNAME=%s\n' % user_name)
    env_file.write('export OS_PASSWORD=%s\n' % user_password)
    env_file.write('export OS_TENANT_NAME=%s\n' % user_tenant_name)
    env_file.write('export OS_AUTH_URL=http://%s:5000/v2.0\n' % auth_ip)
    env_file.write('export INSTANCE_NETWORK=%s\n' % server_networks)
    env_file.write('export INSTANCE_PASSWORD=%s\n' % server_adminPass)
    env_file.close()

    print '\nStart vm...'
    print 'OK!\n'

if __name__ == '__main__':
    auth_conn.close()
    nova_conn.close()
    neutron_conn.close()
    api_token = gen_token()
    user_tenant_id = get_tenant_id(api_token)
    create_server(api_token, user_tenant_id)
