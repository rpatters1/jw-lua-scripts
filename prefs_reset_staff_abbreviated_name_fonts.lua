function plugindef()
    -- This function and the 'finaleplugin' namespace
    -- are both reserved for the plug-in definition.
    finaleplugin.Author = "Robert Patterson"
    finaleplugin.Copyright = "CC0 https://creativecommons.org/publicdomain/zero/1.0/"
    finaleplugin.Version = "1.0.2"
    finaleplugin.Date = "June 12, 2020"
    finaleplugin.CategoryTags = "Staff"
    return "Reset Abbreviated Staff Name Fonts", "Reset Abbreviated Staff Name Fonts",
           "Reset all abbreviated staff names to document's default font settings."
end

local path = finale.FCString()
path:SetRunningLuaFolderPath()
package.path = package.path .. ";" .. path.LuaString .. "?.lua"
local library = require("library.general_library")
local enigma_string = require("library.enigma_string")

function prefs_reset_staff_abbreviated_name_fonts()
    local sel_region = library.get_selected_region_or_whole_doc()
    local font_info = finale.FCFontInfo()
    font_info:LoadFontPrefs(finale.FONTPREF_ABRVSTAFFNAME)
    local sys_staves = finale.FCSystemStaves()
    sys_staves:LoadAllForRegion(sel_region)
    for sys_staff in each(sys_staves) do
        local staff = finale.FCStaff()
        staff:Load(sys_staff:GetStaff())
        local staff_name_id = staff:GetAbbreviatedNameID()
        if 0 ~= staff_name_id then
            text_block = finale.FCTextBlock()
            if text_block:Load(staff_name_id) then
                if enigma_string.change_first_text_block_font(text_block, font_info) then
                    text_block:Save()
                end
            end
        end
    end
    -- duplicate patterson plugin functionality which updates staff styles if the entire document is selected
    if sel_region:IsFullDocumentSpan() then
        local staff_styles = finale.FCStaffStyleDefs()
        staff_styles:LoadAll()
        for staff_style in each(staff_styles) do
            if staff_style.UseAbbreviatedName then
                text_block = finale.FCTextBlock()
                if text_block:Load(staff_style:GetAbbreviatedNameID()) then
                    if enigma_string.change_first_text_block_font(text_block, font_info) then
                        text_block:Save()
                    end
                end
            end
        end
    end
end

prefs_reset_staff_abbreviated_name_fonts()
