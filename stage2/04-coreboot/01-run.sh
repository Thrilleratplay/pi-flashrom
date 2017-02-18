#!/bin/bash -e

on_chroot << EOF
  aptitude install flashrom
EOF
