#!/usr/bin/env python

# -----------------------------------------------------------------------------
# Name        : Caio Quinilato Teixeira
# Email       : caio.quinilato@gmail.com
# Repository  : https://github.com/github/dotfiles
# Description : Script to configure Fedora
# -----------------------------------------------------------------------------

import os
import logging
import colorlog

def setup_logger(name):
    """Set up a logger with colored console output and file output."""
    # Create the log directory if it doesn't exist
    log_dir = os.path.expanduser('~/.local/share/my_script_logs')
    os.makedirs(log_dir, exist_ok=True)
    log_file_path = os.path.join(log_dir, 'installation.log')

    # Configure colored logging for console
    console_handler = colorlog.StreamHandler()
    console_handler.setFormatter(colorlog.ColoredFormatter(
        '%(log_color)s%(asctime)s - %(levelname)s - %(message)s',
        datefmt=None,
        reset=True,
        log_colors={
            'DEBUG':    'cyan',
            'INFO':     'green',
            'WARNING':  'yellow',
            'ERROR':    'red',
            'CRITICAL': 'red,bg_white',
        }
    ))

    # Configure logging for file
    file_handler = logging.FileHandler(log_file_path)
    file_handler.setFormatter(logging.Formatter(
        '%(asctime)s - %(levelname)s - %(message)s'
    ))

    # Set up logger
    logger = colorlog.getLogger(name)
    logger.addHandler(console_handler)
    logger.addHandler(file_handler)
    logger.setLevel(logging.DEBUG)

    return logger
