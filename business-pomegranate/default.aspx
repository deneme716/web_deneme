<%@ Page Language="VB" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Xml" %>
<script language="VB" runat="server">

	' Declare strings to point to our XML and XSD files
	Dim strXmlDocument As String = Server.MapPath("guestbook.xml")
	Dim strXmlSchema   As String = Server.MapPath("guestbook.xsd")

	Sub Page_Load(sender as Object, e as EventArgs)
		' Read our XML file into an XmlDataDocument so
		' we can access it as a DataSet
		Dim myXmlDataDocument As New XmlDataDocument()
		myXmlDataDocument.DataSet.DataSetName = "Guestbook"
		myXmlDataDocument.DataSet.ReadXmlSchema(strXmlSchema)
		myXmlDataDocument.Load(strXmlDocument)

		' Databind our datasource to our guestbook repeater
        GuestbookEntryRepeater.DataSource = myXmlDataDocument.Dataset.Tables("Entry")
        GuestbookEntryRepeater.DataBind()
	End Sub

	Sub btnSignGuestbook_OnClick(sender as Object, e as EventArgs)
		' Read our XML file into an XmlDataDocument so
		' we can access it as a DataSet
		Dim myXmlDataDocument As New XmlDataDocument()
		myXmlDataDocument.DataSet.DataSetName = "Guestbook"
		myXmlDataDocument.DataSet.ReadXmlSchema(strXmlSchema)
		myXmlDataDocument.Load(strXmlDocument)

		' Get a shorter name that points at our table to make things easier
        Dim GuestbookEntriesTable As DataTable
        GuestbookEntriesTable = myXmlDataDocument.Dataset.Tables("Entry")

		' Create a new row for the new guestbook entry
		Dim myDataRow As DataRow		
		myDataRow = GuestbookEntriesTable.NewRow
		
		' Set the row's data values
		myDataRow.Item("Name") = txtName.Text
		myDataRow.Item("Date") = Now()
		myDataRow.Item("Message") = txtMessage.Text

		' Add the row to our table
		GuestbookEntriesTable.Rows.Add(myDataRow)

		' Write changes back to table
		myDataRow.AcceptChanges

		' Write changes back to DataSet
		myXmlDataDocument.DataSet.AcceptChanges
		
		' Write new XML file (including new entry) over old one
		myXmlDataDocument.DataSet.WriteXml(strXmlDocument, XmlWriteMode.IgnoreSchema)
		
        ' Databind our datasource to our guestbook repeater
        ' I do this so the new entry is visible immediately
        GuestbookEntryRepeater.DataSource = GuestbookEntriesTable
        GuestbookEntryRepeater.DataBind()
	End Sub
</script>

<html>
<head>
<title>ASP.NET Guestbook Sample</title>
</head>
<body>

<h3>Sign Our Guestbook:</h3>

<form runat="server">

<table>
  <tr>
    <th align="right">Name:</td>
    <td>
		<asp:TextBox id="txtName" size="20" runat="server" />
		<asp:RequiredFieldValidator runat="server"
			id="validNameRequired" ControlToValidate="txtName"
			errormessage="Please enter your name."
			display="Dynamic" />
    </td>
  </tr>
  <tr>
    <th align="right">Comment:</td>
    <td>
		<asp:TextBox id="txtMessage" size="35" runat="server" />
		<asp:RequiredFieldValidator runat="server"
			id="validMessageRequired" ControlToValidate="txtMessage"
			errormessage="Please enter a message."
			display="Dynamic" />
    </td>
  </tr>
</table>

<asp:Button id="btnSignGuestbook" text="Sign Guestbook!"
	OnClick="btnSignGuestbook_OnClick" runat="server" />

</form>

<hr />

<asp:Repeater id=GuestbookEntryRepeater runat="server">
    <HeaderTemplate>
		<h3>User Comments:</h3>
    </HeaderTemplate>

    <ItemTemplate>
		<strong><%# DataBinder.Eval(Container.DataItem, "Name") %>:</strong>
		<%# DataBinder.Eval(Container.DataItem, "Message") %>
		<br />
    </ItemTemplate>

	<FooterTemplate>
		<hr />
	</FooterTemplate>
</asp:Repeater>

</body>
</html>
