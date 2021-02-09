/*
 * Copyright (C) 2014 Szymon Waliczek.
 *
 * Authors:
 *  Szymon Waliczek <majsterrr@gmail.com>
 *
 * This file is part of SocketWorld app for Ubuntu Touch
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


Component {
    id: dialog

    // bout dialog
    Dialog {
        id: dialogue
        title: app_name_get()
        text: i18n.tr("Version") + " %1".arg(manifestMODEL.model.get(0).version)

        // this function will pull "title" section from manifest.json file and make first leter as upper case.
        function app_name_get() {
            var name = manifestMODEL.model.get(0).title.split("-")
            var new_name = []
            for (var i = 0; i < name.length; i++){
                new_name.push(name[i].charAt(0).toUpperCase() + name[i].slice(1))
            }
            return new_name.join(" ")
        }
        Flickable {
            width: mainView.width
            height: mainView.height
            contentWidth: width
            contentHeight: label1.height + label2.height + label3.height + label4.height + label5.height + icon1.height + units.gu(40)
            clip: true



            // Item to holds column with images and labels
            Item {
                width: parent.width
                height: units.gu(35)
                Column {
                    anchors.fill: parent
                    spacing: units.gu(2)

                    // application icon image
                    UbuntuShape {
                        id: icon1
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: units.gu(12)
                        height: units.gu(12)
                        image: Image {
                            source: Qt.resolvedUrl("../socketworld.png")
                        }
                    }
                    // licence label
                    Label {
                        id: label1
                        width: parent.width
                        font.pointSize: units.gu(1.2)
                        text: i18n.tr("<b>Licence: </b> GPL v3")
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }
                    // author label
                    Label {
                        id: label2
                        width: parent.width
                        font.pointSize: units.gu(1.2)
                        text: i18n.tr("<b>Author:</b><br>Szymon Waliczek<br>
                                        <a href=\"mailto://majsterrr@gmail.com\">majsterrr@gmail.com</a>")
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }

                    // contributors label ( will addopt flickable according to height of this label and other too )
                    Label {
                        id: label3
                        width: parent.width
                        font.pointSize: units.gu(1.2)
                        text: i18n.tr("<b>Contributors:</b>
                                   <br>Sam Hewitt (icon)<br>
                                        <a href=\"mailto://snwh@ubuntu.com\">snwh@ubuntu.com</a>
                                   ")
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }



                    // lanchpad course code link
                    Label {
                        id: label4
                        width: parent.width
                        font.pointSize: units.gu(1.2)
                        text: i18n.tr('<html><style type="text/css"></style><b>Source Code:</b> <a href="https://launchpad.net/socketworld">Launchpad</a></html>')
                        onLinkActivated: Qt.openUrlExternally(link)
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }

                    // link to website from which I used data and some images.
                    Label {
                        width: parent.width
                        id: label5
                        font.pointSize: units.gu(1.2)
                        text: i18n.tr('<html><style type="text/css"></style><b>Images and informations used in this app borrowed from:</b> <a href="http://www.iec.ch/worldplugs/">www.iec.ch</a></html>')
                        onLinkActivated: Qt.openUrlExternally(link)
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WordWrap
                    }

                    // close button
                    Button {
                        width: parent.width
                        text: i18n.tr("Close")
                        onClicked: PopupUtils.close(dialogue)
                    }

                }


            }
        }


    }
}


