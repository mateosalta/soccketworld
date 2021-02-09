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


// this is ListItem of Plug ( this is used to display 4 different plugs in one listItem
Item {
    property alias thumbnail: thumbnail.source
    property alias label: label.text
    signal click

    // column to holds image and label underneath the image.
    Column {
        anchors.fill: parent
        // image
        UbuntuShape {
            id: shape
            height: parent.height
            width: height
            radius: "medium"
            image: Image {
                id: thumbnail
            }
        }
        // label underneath image
        Label {
            id: label
            color: "gray"
            height: units.gu(1)
            font.bold: true
            fontSize: "small"
        }
    }

    // adding click signal to this element
    MouseArea {
        anchors.fill: parent
        onClicked: click()
    }
}
