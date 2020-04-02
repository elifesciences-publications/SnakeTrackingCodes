%============================ blobFilter ============================
%
%  Returns the handle to an image processor that applies an oriented
%  blob filter.  An oriented filter is essentially a filter bank of
%  blob filters that are rotated at different angles.  The orientation
%  of a pixel is determined by the strongest response associated to one
%  of the filters, thus the orientation is typically quantized relative to
%  the standard 0 and 90 degree blob filter pairing which results in a
%  vector.
%
%  The image is expected to be a grayscale image.
%
%
%  INPUTS:
%
%    threshold	- threshold value for detection.
%
%    bparms		- extra parameters that assist with processing/visualization.
%				  structure whose optional fields are:
%					debug	- debug level	[ 0 ]
%					sigma	- variance of the Gabor filter Gaussian.
%					nstds	- Filter size as a factor of sigma.
%					bounds	- boundary processing ['replicate']
%							  see imfilter help for options.
%					detect	- detection type ['hard']
%							'hard' 		- threshold is hard.
%							'factor'	- factor of the max value.
%							'percent'	- percentage of image to use as blobs.
%
%
%============================ blobFilter ============================

%
%  Name:		blobFilter.m
%
%  Author:		Miguel Serrano,
%				Patricio A. Vela
%
%  Created:		2011/07/13
%  Modified:	2011/07/13
%
%  Notes:
%    set tabstop to 4 to align text properly.
%
%============================ blobFilterGabor ============================
function bbfh = blobFilterBank(threshold, bparms)


%-- 1] Process arguments and setup default parameters, if missing.
if ((nargin < 2) || isempty(bparms))
    bparms = struct('debug', 0);
end

if ((nargin < 1) || isempty(threshold))
    threshold = 0;
end

setIfMissing('debug', 0);
setIfMissing('bounds', 'replicate');
setIfMissing('detect', 'hard');
setIfMissing('pArgs',{'Color', 'r'});

setIfMissing('sign',1);
setIfMissing('nstds', 3);
setIfMissing('sigma',[1 1]); % [sigma_x sigma_y]
setIfMissing('num_Filt',4);
setIfMissing('pace','none');

if max(size(bparms.sigma)) == 1
    bparms.sigma = [bparms.sigma bparms.sigma];
end

%-- 2] Instantiation filter member interface functions.
filt = genFilt();

switch (bparms.detect)
    case {'hard', 'factor', 'percent'}
        detect_blobs = eval(['@detect_blobs_' bparms.detect]);
    otherwise
        error('Detection threshold type not recognized (it is case sensitive).');
end

bbfh.setThreshold = @set_threshold;
bbfh.setstd       = @set_std;
bbfh.getThreshold = @get_threshold;

bbfh.apply           = @apply_filter;
%bbfh.detect = detect_blobs;
bbfh.process         = @blobs_process;
bbfh.display         = @blobs_display;

%
%============================ Member Functions ===========================
%

%---------------------------- setIfMissing ---------------------------
%
%(
    function setIfMissing(fname, fval)
        
        if (~isfield(bparms, fname))
            bparms = setfield(bparms, fname, fval);
        end
        
    end
%)
%--------------------------- genFilter ---------------------------
% apply the closed form solution to the laplacian of gaussian
%
%
    function filt = genFilt()
        sigma_x = bparms.sigma(1);
        
        % Rotation
        filt = cell(1,bparms.num_Filt);
        for m = 1:bparms.num_Filt
            % Keeping it real
            filt{m} = bparms.sign*fspecial('log',[2*floor(bparms.nstds*sigma_x)+1 ...
                2*floor(bparms.nstds*sigma_x)+1 ], m/bparms.num_Filt*sigma_x);
        end
        if bparms.debug
            figure(10)
            for m = 1:bparms.num_Filt
                subplot(ceil(sqrt(bparms.num_Filt)),ceil(sqrt(bparms.num_Filt)),m)
                imagesc(filt{m});
                axis image
            end
        end
    end
%)
%--------------------------- set_threshold ---------------------------
%
%(
    function set_threshold(nthresh)
        threshold = nthresh;
    end
%)
%--------------------------- set_std ---------------------------
%
%(
    function set_std(stddd)
        bparms.sigma(1) = stddd;
    end
%)
%--------------------------- get_threshold ---------------------------
%
%(
    function rthresh = get_threshold
        rthresh = threshold;
    end
%)
%---------------------------- apply_filter ---------------------------
%
%(
    function fI = apply_filter(I)
        if strcmp(bparms.pace,'cuda')
            J = gsingle(zeros(max(size(filt)),size(I,1), size(I,2)));
            for m = 1:max(size(filt))
                J(m,:,:)= imfilter( I, gsingle(filt{m}), bparms.bounds, 'same');
            end
        else
            J = zeros(max(size(filt)),size(I,1), size(I,2));
            for m = 1:max(size(filt))
                J(m,:,:)= double(imfilter( single(I), filt{m}, bparms.bounds, 'same'));
            end
        end
        
        if size(J,1) == 1
            fI = squeeze(J);
        else
            fI = squeeze(max(J));
        end
    end
%)
%---------------------------- detect_blobs ---------------------------
%
%(
    function blobs = detect_blobs_hard(mag)
        
        ifail = mag < threshold;
        
        mag(ifail) = -1;
        
        blobs.bmap = ~ifail;
        blobs.mag  = mag;
        
    end
    function blobs = detect_blobs_factor(mag)
        
        ifail = mag < (max(abs(mag(:)))*threshold/100);
        
        mag(ifail) = 0;
        
        blobs.bmap = ~ifail;
        blobs.mag  = mag;
        
    end
    function blobs = detect_blobs_percent(mag)
        
        msort = sort(mag(:), 'descend');
        ival = round(max(1, min(numel(mag), numel(mag)*threshold/100)));
        
        athresh = msort(ival);
        
        ifail = mag < athresh;
        
        mag(ifail) = 0;
        
        blobs.bmap = ~ifail;
        blobs.mag  = mag;
        
    end
%)
%--------------------------- blobs_process ---------------------------
%
%(
    function blobs = blobs_process(I)
        
        mag = apply_filter(I);
        blobs = detect_blobs(mag);
        
    end
%)
%------------------------ blobs_displayNormal ------------------------
%
%  Plots the blob normal vectors.
%(
    function blobs_display(b)
        
        washeld = ishold;
        if (~washeld)
            hold on;
        end
        
        L = BWLABEL(b.bmap, 8);
        for m = 1:max(L(:))
            [y,x] = ind2sub(size(L), find(L==m));
            x_c(m) = mean(x);
            y_c(m) = mean(y);
        end
        
        plot(x_c, y_c , 'ro')
        c = edge(b.bmap);
        [y,x] = ind2sub(size(b.bmap), find(c==1));
        plot(x,y, '.y', 'MarkerSize', .5 )
        
        if (~washeld)
            hold off;
        end
        
    end
%)
end
%
%============================ blobFilterGabor ============================
