# Other attributes that can be used with -AccessRights

# Owner — read, create, modify and delete all items and folders. Also, this role allows managing items permissions

# PublishingEditor — read, create, modify and delete items/subfolders

# Editor — read, create, modify and delete items

# PublishingAuthor — read, create all items/subfolders. You can modify and delete only items you create

# Author — create and read items; edit and delete own items

# NonEditingAuthor – full read access and create items. You can delete only your own items

# Reviewer — read-only

# Contributor — create items and folders

# AvailabilityOnly — read free/busy information from the calendar

# LimitedDetails

# None — no permissions to access folders and files

# View calendar permissions of a specific mailbox
Get-MailboxFolderPermission username:\calendar

# Add calendar permissions = In the example below, user2 would be able to open user1 calendar and edit
Add-MailboxFolderPermission -Identity user1@chewy.com:\calendar -user user2@chewy.com -AccessRights Editor -SharingPermissionFlags Delegate

# Remove calendar permissions = From user2
Remove-MailboxFolderPermission -Identity meamer@chewy.com:\calendar -user comarra@chewy.com

# to make sure changes has taken place as requested
Get-MailboxFolderPermission meamer@chewy.com:\calendar