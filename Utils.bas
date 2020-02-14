B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.8
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
End Sub

Sub sortedList(imageNames As List) As List
	Dim newList As List
	newList.Initialize
	Dim parents As Map
	parents.Initialize

	For Each name As String In imageNames
		Dim parent As String=GetParent(name)
		If parent="" Then
			parent="root"
		End If
		Dim files As List
		files.Initialize
		If parents.ContainsKey(parent) Then
			files=parents.Get(parent)
		End If
		files.Add(name)
		parents.Put(parent,files)

	Next
	For Each parent As String In parents.Keys
		Dim files As List
		files=parents.Get(parent)
		Dim nameMap As Map
		nameMap.Initialize
		Dim names As List
		names.Initialize
		Dim SortAsNumber As Boolean
		SortAsNumber=CanBeSortedAsNumber(files)
		For Each filename As String In files
			Dim pureFilename As String=GetFilenameWithoutExtensionAndParent(filename)
			nameMap.Put(pureFilename,filename)
			If SortAsNumber Then
				Dim nameAsInt As Int
				Try
					nameAsInt=pureFilename
					names.Add(nameAsInt)
				Catch
					Log(LastException)
				End Try
			Else
				names.Add(pureFilename)
			End If
		Next
		Log(names)
		names.Sort(True)
		Log(names)
		For Each name As String In names

			newList.Add(nameMap.Get(name))
		Next
	Next
	Log(newList)
	Return newList
End Sub

Sub CanBeSortedAsNumber(files As List) As Boolean
	For Each filename As String In files
		Dim pureFilename As String=GetFilenameWithoutExtensionAndParent(filename)
		If pureFilename.StartsWith("0") Then
			Return False
		End If
		Dim nameAsInt As Int
		Log(filename)
		Log(pureFilename)
		Try
			nameAsInt=pureFilename
		Catch
			Log(LastException)
			Return False
		End Try
	Next
	Return True
End Sub


Sub GetFilenameWithoutExtensionAndParent(filename As String) As String
	Try
		If filename.Contains(".") Then
			filename=filename.SubString2(0,filename.LastIndexOf("."))
		End If
		If filename.Contains("/") Then
			filename=filename.SubString2(filename.LastIndexOf("/")+1,filename.Length)
		End If
		If filename.Contains("\") Then
			filename=filename.SubString2(filename.LastIndexOf("\")+1,filename.Length)
		End If
	Catch
		Log(LastException)
	End Try
	Return filename
End Sub

Sub GetParent(filename As String) As String
	Dim parent As String
	If filename.Contains("/") Then
		parent=filename.SubString2(0,filename.LastIndexOf("/"))
	End If
	If filename.Contains("\") Then
		parent=filename.SubString2(0,filename.LastIndexOf("\"))
	End If
	Return parent
End Sub

Sub GetParentWithoutSlashes(filename As String) As String
	Dim parent As String=GetParent(filename)
	parent=parent.Replace("/","")
	parent=parent.Replace("\","")
	Return parent
End Sub