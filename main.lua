local lfs = require('lfs')

-- File type extensions
local typeext = {
  image = { ".jpg", ".png", ".jpeg", ".webm" },
  text = { ".txt", ".pdf", ".doc", ".docx" },
  audio = { ".mp3", ".wav" },
  video = { ".mp4", ".avi", ".mkv", ".wmv" },
  archive = { ".zip", ".rar", ".gz", ".tar" },
  code = { ".py", ".pyc", ".cpp", ".c", ".lua", ".js", ".ts", ".tsx" },
  executable = { ".exe", ".msi", ".bat", ".sh" },
  font = { ".ttf", ".otf" },
  spreadsheet = { ".xls", ".xlsx" },
  presentation = { ".ppt", ".pptx" },
}

-- Read user input
io.write("Enter source folder path: ")
local src_dir = io.read()
io.write("Enter destination folder path: ")
local dst_dir = io.read()

-- Iterate through files in the source directory
do
  local function table_contains(table, value)
    for _, v in ipairs(table) do
      if v == value then
        return true
      end
    end
    return false
  end

  for file in lfs.dir(src_dir) do
    if file ~= '.' and file ~= '..' then
      local file_path = src_dir .. '/' .. file
      local dest_path

      -- Determine file type based on extension
      local extension = string.match(file, "%.[^.]+$")
      if not extension then
        dest_path = dst_dir .. '/other'
      else
        for type, extensions in pairs(typeext) do
          if table_contains(extensions, extension) then
            dest_path = dst_dir .. '/' .. type
            break
          end
        end
        if not dest_path then
          dest_path = dst_dir .. '/other'
        end
      end

      -- Create subdirectory in destination directory if it doesn't exist
      print(string.format("Creating folder %s", dest_path))
      lfs.mkdir(dest_path)

      -- Move file to appropriate subdirectory in destination directory
      print(string.format("Moving %s to %s", file_path, dest_path))
      os.rename(file_path, dest_path .. '/' .. file)
    end
  end
end
