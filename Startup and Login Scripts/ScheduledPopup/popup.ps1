Function New-WPFDialog() {
        <#
        .SYNOPSIS
        This neat little function is based on the one from Brian Posey's Article on Powershell GUIs
    
    .DESCRIPTION
      I re-factored a bit to return the resulting XaML Reader and controls as a single, named collection.

    .PARAMETER XamlData
     XamlData - A string containing valid XaML data

    .EXAMPLE

      $MyForm = New-WPFDialog -XamlData $XaMLData
      $MyForm.Exit.Add_Click({...})
      $null = $MyForm.UI.Dispatcher.InvokeAsync{$MyForm.UI.ShowDialog()}.Wait()

    .NOTES
    Place additional notes here.

    .LINK
      http://www.windowsnetworking.com/articles-tutorials/netgeneral/building-powershell-gui-part2.html

    .INPUTS
     XamlData - A string containing valid XaML data

    .OUTPUTS
     a collection of WPF GUI objects.
  #>
    
    Param([Parameter(Mandatory = $True, HelpMessage = 'XaML Data defining a GUI', Position = 1)]
        [string]$XamlData)
    
    # Add WPF and Windows Forms assemblies
    try {
        Add-Type -AssemblyName PresentationCore, PresentationFramework, WindowsBase, system.windows.forms
    }
    catch {
        Throw 'Failed to load Windows Presentation Framework assemblies.'
    }
    
    # Create an XML Object with the XaML data in it
    [xml]$xmlWPF = $XamlData
    
    # Create the XAML reader using a new XML node reader, UI is the only hard-coded object name here
    Set-Variable -Name XaMLReader -Value @{ 'UI' = ([Windows.Markup.XamlReader]::Load((new-object -TypeName System.Xml.XmlNodeReader -ArgumentList $xmlWPF))) }

    # Create hooks to each named object in the XAML reader
    $Elements = $xmlWPF.SelectNodes('//*[@Name]')
    ForEach ( $Element in $Elements ) {
        $VarName = $Element.Name
        $VarValue = $XaMLReader.UI.FindName($Element.Name)
        $XaMLReader.Add($VarName, $VarValue)
    }

    return $XaMLReader
}


Function New-PopUpWindow () {
    param(
        [string]
        $MessageText = "No Message Supplied")

    # This is the XaML that defines the GUI.
    $WPFXamL = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Popup" Background="#FF0066CC" Foreground="#FFFFFFFF" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" SizeToContent="WidthAndHeight" WindowStyle="None" Padding="20" Margin="0">
    <Grid>
        <Button Name="OKButton" Content="OK" HorizontalAlignment="Right" Margin="0,0,30,20" VerticalAlignment="Bottom" Width="75" Background="#FF0066CC" BorderBrush="White" Foreground="White" Padding="8,4"/>
        <TextBlock Name="Message" Margin="100,60,100,80" TextWrapping="Wrap" Text="_CONTENT_" FontSize="36"/>
    </Grid>
</Window>
'@

    # Build Dialog
    $WPFGui = New-WPFDialog -XamlData $WPFXaml
    $WPFGui.Message.Text = $MessageText
    $WPFGui.OKButton.Add_Click( { $WPFGui.UI.Close() })
    $null = $WPFGUI.UI.Dispatcher.InvokeAsync{ $WPFGui.UI.ShowDialog() }.Wait()
}

New-PopUpWindow -MessageText "Please check Stuff or else."