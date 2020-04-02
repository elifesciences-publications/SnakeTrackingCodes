function a = check_Properties(f, str)
% classes are not struct or so you would believe because isfield does not
% return properties on a class
a = sum(strcmp(fieldnames(f), str)) > 0;
end