<%@ Page Language="VB" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Xml" %>
<script language="VB" runat="server">

	Sub Page_Load(sender as Object, e as EventArgs)
	End Sub
	
	Sub btnClearGuestbook_OnClick(sender as Object, e as EventArgs)

		Dim myXmlDocument As String = Server.MapPath("guestbook.xml")
		Dim myXmlSchema   As String = Server.MapPath("guestbook.xsd")

		Dim myDataSet As New DataSet()
		myDataSet.DataSetName = "Guestbook"

        Dim entryDataTable As DataTable = new DataTable("Entry")

        ' Set up the columns in the table
        Dim colName    as DataColumn = new DataColumn("Name", GetType(System.String))
        Dim colDate    as DataColumn = new DataColumn("Date", GetType(System.DateTime))
        Dim colMessage as DataColumn = new DataColumn("Message", GetType(System.String))

        ' Add columns to table
        Dim id as DataColumn = entryDataTable.Columns.Add("ID", GetType(System.Int32))
        id.AutoIncrement = True
        Dim primarykey as DataColumn() = new DataColumn() {id}
        entryDataTable.PrimaryKey = primarykey
        entryDataTable.Columns.Add(colName)
        entryDataTable.Columns.Add(colDate)
        entryDataTable.Columns.Add(colMessage)

        ' Add table to the DataSet
        myDataSet.Tables.Add(entryDataTable)

        ' Add an entry to the table
        Dim myEntry as DataRow = entryDataTable.NewRow()
        myEntry(colName) = "John"
        myEntry(colDate) = Now()
        myEntry(colMessage) = "I hope you like our guestbook!"
        entryDataTable.Rows.Add(myEntry)

        ' Commit changes
        myDataSet.AcceptChanges()

        ' Write out schema
        myDataSet.WriteXmlSchema(myXmlSchema)

        'Write out XML data
        myDataSet.WriteXml(myXmlDocument, XmlWriteMode.IgnoreSchema)

		lblGuestbookCleared.Text = "Guestbook Cleared!"
	End Sub

</script>

<html>
<head>
<title>ASP.NET Guestbook Sample</title>
</head>
<body>

<p>
Press the button below to erase the guestbook file and replace it
with a new one with one entry.
</p>

<form runat="server">

<asp:Button id="btnClearGuestbook" text="Clear Guestbook"
	OnClick="btnClearGuestbook_OnClick" runat="server" />

</form>

<asp:Label id="lblGuestbookCleared" runat="server" />

<p>
<a href="guestbook.aspx">Back to the guestbook</a>
</p>

</body>
</html>
