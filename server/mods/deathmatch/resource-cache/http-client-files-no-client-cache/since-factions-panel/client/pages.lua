Panel.pages = {
    {
        name = "Informacje",
        icon = "home",
        description = "Informacje o frakcji",
        render = Panel.pages.renderInformationPage
    },
    {
        name = "Członkowie",
        icon = "cmd",
        description = "Lista członków frakcji",
        render = Panel.pages.renderMembersPage,
        onEnter = Panel.pages.membersOnEnter,
        onExit = Panel.pages.membersOnExit,
        onClick = Panel.pages.clickMembersPage
    }
}