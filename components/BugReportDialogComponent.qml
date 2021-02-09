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

    // BugReport Dialog
    Dialog {
        id: dialogue
        title: i18n.tr("Reporting bug...")
        text: i18n.tr("Please help me keep this app in top quality level by reporting any bugs."+"<br><br>"+ i18n.tr("Thank you!"))

        // item to holds column with images and labels etc.
        Item {
            width: parent.width
            height: units.gu(20)
            Column {
                anchors.fill: parent

                // image with funny BUG :D
                UbuntuShape {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: units.gu(12)
                    height: units.gu(12)
                    image: Image {
                        source: Qt.resolvedUrl("../img/deco/bug.jpg")
                    }
                }
            }
        }

        // Button which opens web brawser with link to lanchpad/bugtracker
        Button {
            text: i18n.tr("Report Bug")
            color: "red"
            onClicked: {
                PopupUtils.close(dialogue)
                Qt.openUrlExternally("https://bugs.launchpad.net/socketworld")
            }
        }

        // button to close this dialog
        Button {
            text: i18n.tr("Close")
            onClicked: PopupUtils.close(dialogue)
        }

    }
}
