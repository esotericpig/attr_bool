# encoding: UTF-8
# frozen_string_literal: true

#--
# This file is part of AttrBool.
# Copyright (c) 2020 Bradley Whited
#
# SPDX-License-Identifier: MIT
#++

require 'attr_bool'

# This works for both `class` & `module` because `class` extends `module`.
Module.prepend(AttrBool::Ext)
