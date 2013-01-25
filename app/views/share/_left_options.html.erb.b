<ul id="left-menu">
<% if signed_in? %>
  <li class="menu-item">
    <a data-target="#message">Messages</a>
    <ul id="message" class="menu-body">
      <li><%= link_to "Unread", mails_path(folder: "unread") %></li>
      <li><%= link_to "Compose", new_mail_path %></li>
      <li><%= link_to "Inbox", mails_path(folder: "inbox") %></li>
      <li><%= link_to "Sent", mails_path(folder:"sent") %></li>
      <li><%= link_to "All", mails_path(folder: "all")%></li>
    </ul>
  </li>

  <li class="menu-item">
    <a data-target="#friend">Friends</a>
    <ul id="friend" class="menu-body">
      <li><%=link_to "Pending Requests", relationships_path(type: "pending") %></li>
      <li><%=link_to "All Friends", relationships_path(type: "friends")%></li>
      <li><%=link_to "Requested", relationships_path(type: "request") %></li>
      <li><%=link_to "Blocked", relationships_path(type: "block") %></li>
      <li><%=link_to "Suggest Friend", relationships_path(type: "suggest") %></li>
      <li><%=link_to "Find a Friend", users_path %></li>
    </ul>
  </li>
<% end %>

  <li class="menu-item">
    <a data-target="#v">v</a>
    <ul id="v" class="menu-body">
      <li><%= link_to "About", about_path %></li>
      <li><%= link_to "Help", help_path %></li>
      <li><%= link_to "Contact Us", contact_path %></li>
    </ul>
  </li>





</ul>
