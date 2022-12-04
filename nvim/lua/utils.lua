local M = {}

M.ends_with = function(str, ending)
  return ending == "" or str:sub(- #ending) == ending
end

return M
