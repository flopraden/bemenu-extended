#! /usr/bin/env python
# -*- coding: utf8 -*-
import os
from distutils.core import setup

setup(name='bemenu_extended',
      version='0.1.0',
      description='A wrapper for bemenu that implements plugins and fast file/folder searching',
      author='Mark H. Jones',
      author_email='none@none.none',
      url='https://github.com/flopraden/bemenu-extended',
      packages=['bemenu_extended'],
      scripts=['scripts/bemenu_extended_run', 'scripts/bemenu_extended_cache_build'],
      data_files=[('share/bemenu-extended/', ['scripts/systemd-install.sh']),
                  ('share/bemenu-extended/systemd', ['systemd/update-bemenu-extended-db.timer'])]
      )
