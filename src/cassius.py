#!/usr/bin/env python
# Imports basic JATS XML documents into CaSSius-compatible HTML document formats
# Copyright Martin Paul Eve 2020

"""cassius: Imports a JATS XML document into a CaSSius-compatible HTML document

Usage:
    cassius.py <in-file> <out-file> [options]
    cassius.py (-h | --help)
    cassius.py --version

Options:
    -d, --debug                                     Enable debug output.
    -h --help                                       Show this screen.
    --version                                       Show version.
"""

import os
import sys
from os import listdir
from os.path import isfile, join
import re
from bs4 import BeautifulSoup
from debug import Debug, Debuggable
from docopt import docopt
from interactive import Interactive
import subprocess

from lxml import etree


class CassiusImport(Debuggable):
    def __init__(self):
        # read  command line arguments
        self.args = self.read_command_line()

        # absolute first priority is to initialize debugger so that anything triggered here can be logged
        self.debug = Debug()

        Debuggable.__init__(self, 'CaSSius')

        self.in_file = self.args['<in-file>']
        self.out_file = self.args['<out-file>']

        self.xsl_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'CaSSius.xsl')

        if self.args['--debug']:
            self.debug.enable_debug()

        self.debug.enable_prompt(Interactive(self.args['--debug']))

    def render_xml(self, file_to_render, xsl_path=None):
        """Renders XML with the given XSL path or the default XSL.

        :param file_to_render: the file object to retrieve and render
        :param article: the associated article
        :param xsl_path: optional path to a custom xsl file
        :return: a transform of the file to through the XSLT processor
        """

        path = file_to_render

        if not os.path.isfile(path):
            self.debug.fatal_error(self, "Bad/no XML file for XSLT transform")
            return ""

        if not os.path.isfile(xsl_path):
            self.debug.fatal_error(self, 'The required XSLT file {0} was not found'.format(xsl_path))
            return ""

        with open(path, "rb") as xml_file_contents:
            xml = BeautifulSoup(xml_file_contents, "lxml-xml")

            transform = etree.XSLT(etree.parse(xsl_path))

            # remove the <?xml version="1.0" encoding="utf-8"?> line (or similar) if it exists
            regex = re.compile(r'<\?xml version="1.0" encoding=".+"\?>')
            xml_string = str(xml)
            xml_string = re.sub(regex, '', xml_string, count=1)

            return transform(etree.XML(xml_string))

    @staticmethod
    def read_command_line():
        return docopt(__doc__, version='cassius-import v0.2')

    def run(self):
        self.debug.print_debug(self, u'Running lxml transform (JATS -> CaSSius).')

        try:
            output = self.render_xml(file_to_render=self.in_file, xsl_path=self.xsl_path)
        except TypeError as err:
            self.debug.fatal_error(self, 'Error running transform: {0}'.format(err))
        except:
            self.debug.fatal_error(self, 'Error running transform: {0}'.format(sys.exc_info()[0]))
            return

        try:
            with open('tmp_out.html', 'w') as out_file:
                out_file.write(str(output))
        except:
            self.debug.fatal_error(self, u'Error writing to temporary output file {0}.'.format(self.out_file))
            return

        commands = [
            'google-chrome --headless --disable-gpu --print-to-pdf={0} --virtual-time-budget=50000000 --run-all-compositor-stages-before-draw --disable-web-security {1} >/dev/null 2>&1'.format(
                self.out_file, 'tmp_out.html'),
        ]

        if not self.debug.debug:
            commands += 'rm tmp_out.html'

        for command in commands:
            self.debug.print_debug(self, "Calling shell script {0}".format(command))
            subprocess.call(command, shell=True)

        self.debug.print_debug(self, u'Done.')


def main():
    cwf_instance = CassiusImport()
    cwf_instance.run()


if __name__ == '__main__':
    main()
