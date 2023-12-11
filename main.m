%majority uses code from proj_SFF_J2, just adjusted.
% -------------------------------------------------------------------------
%     CONSTANTS      
% -------------------------------------------------------------------------

const.r2d       = 180/pi;                       % radians-to-degrees
const.mu        = 3.986004354360959e5;          % gravitational parameter [ km^3/s^2 ]
const.R         = 6.3781366e3;                  % mean equatorial radius [ km ]
const.J2        = 1.082635525490e-3;            % oblateness gravity field coefficient

% -------------------------------------------------------------------------
%     INITIAL STATES | CHIEF & DEPUTY
% -------------------------------------------------------------------------

%  Specifiy chief mean orbit element vector. Adjust as needed for the
%  mission
a               = const.R + 445;                % semimajor axis [ km ]
e               = 0.1;                         % eccentricity [ ]
i               = 30;                           % inclination [ deg ]
Om              = 15;                            % right ascension [ deg ]
w               = 30;                           % argument of perigee [ deg ]
M               = 0;                            % mean anomaly [ deg ]


kepc_mean       = [ a; e; i; Om; w; M ];

delta_e = 0.0001;

delta_vector = calc_change_from_input(kepc_mean, const, delta_e, 'e');
%below is copied from your proj_SFF_J2 script with da, de, di adjusted. 
% can adjust others as needed

%  Mean orbit element differnce vector
da              = delta_vector(1);                % semimajor axis difference [ km ]   
de              = delta_vector(3);                       % eccentricity difference [ ]
di              = delta_vector(2);                     % inclination difference [ deg ] 
dOm             = 0.005;                        % ascending node difference [ deg ]
dw              = 0.01;                         % argument of perigee difference [ deg ]
dM              = -0.01;                        % mean anomaly difference [ deg ]

dkep_mean       = [ da; de; di; dOm; dw; dM ];

%  Specifiy deputy mean orbit element vector
kepd_mean       = kepc_mean + dkep_mean;

%  Osculating chief and deputy orbit element vectors  
kepc_osc        = mean2osc( kepc_mean , const , 'mean' , 'deg' );
kepd_osc        = mean2osc( kepd_mean , const , 'mean' , 'deg' );

% kepc_osc = kepc_mean;
% kepd_osc = kepd_mean;

%  Initial Cartesian position and velocity vectors
[ rc0 , vc0 ]   = koe2rv( kepc_osc , const.mu , 0 , 'deg' );
[ rd0 , vd0 ]   = koe2rv( kepd_osc , const.mu , 0 , 'deg' );

% -------------------------------------------------------------------------
%     ORBIT PROPAGATION 
% -------------------------------------------------------------------------

%  Specify number of points in integration 
T               = 2 * pi * sqrt( kepc_osc(1)^3 / const.mu );   
time            = linspace( 0 , 45 * T , 5000 );

%  Set integrator options
tol             = 1e-12;    
options         = odeset( 'RelTol' , tol , 'AbsTol' , tol );

%  Chief inertial position and velocity
xc0             = [ rc0 ; vc0 ];
[ ~ , xc ]      = ode45( @dynamics_Newton , time , xc0 , options , const );
rc              = xc(:,1:3);
vc              = xc(:,4:6);

%  Deputy inertial position and velocity
xd0             = [ rd0 ; vd0 ];
[ ~ , xd ]      = ode45( @dynamics_Newton , time , xd0 , options , const );
rd              = xd(:,1:3);
vd              = xd(:,4:6);

%  Map inertial to Hill frame
rho             = zeros(3, length(time));
for k = 1:length(time)
    
    [ rho(:,k) , ~ ] = Newton2Hill( rc(k,:)', vc(k,:)', rd(k,:)', vd(k,:)' );

end

rho  = rho';

% -------------------------------------------------------------------------
%     FIGURES
% -------------------------------------------------------------------------

mymap = [ [0.875 0.875 0.875] ; [0 0 0] ]; 
set( 0 , 'DefaultAxesColorOrder' , mymap )

idx = find( time < T );

figure(1); 
    plot3( rho(:,1) , rho(:,2) , rho(:,3) );
    hold all
    plot3( rho(idx,1) , rho(idx,2) , rho(idx,3) )
    plot3( 0 , 0 , 0 , 'k.' , 'MarkerSize' , 21 );
    grid on 
    box on         
    hXLabel = xlabel( 'Radial [km]' );
    hYLabel = ylabel( 'Along-Track [km]' );
    hZLabel = zlabel( 'Out-of-Plane [km]' );  
    set( gca , 'FontName' , 'Helvetica' );
    set( [ hXLabel , hYLabel , hZLabel ] , 'FontName' , 'AvantGarde' , ...
         'FontSize' , 10 );
    set( gca , 'TickLength' , [0.01 0.01] );
    set( gcf , 'units' , 'inches' , 'NumberTitle' , 'off' );
    set( gcf , 'position' , [0,6.75,6,4.75] );    
    set( gcf, 'PaperPositionMode' , 'auto' ); 
    saveas(gcf, 'fig1', 'png')

figure(2); 
    plot( rho(:,1) , rho(:,2) );
    hold all
    plot( rho(idx,1) , rho(idx,2) );
    plot( 0 , 0 , 'k.', 'MarkerSize', 21 );    
    grid on         
    hXLabel = xlabel( 'Radial [km]' );
    hYLabel = ylabel( 'Along-Track [km]' );
    set( gca , 'FontName' , 'Helvetica' );
    set( [ hXLabel , hYLabel ] , 'FontName' , 'AvantGarde' , ...
         'FontSize' , 10 );
    set( gca , 'TickLength' , [0.01 0.01] );
    set( gcf , 'units' , 'inches' , 'NumberTitle' , 'off' );
    set( gcf , 'position' , [6,6.75,6,4.75] );     
    set( gcf, 'PaperPositionMode' , 'auto' );   
    saveas(gcf, 'fig2', 'png')
    
figure(3);
    plot( rho(:,1) , rho(:,3) );
    hold all
    plot( rho(idx,1) , rho(idx,3) );
    plot( 0 , 0 , 'k.' , 'MarkerSize' , 21 );    
    grid on
    hXLabel = xlabel( 'Radial [km]' );
    hYLabel = ylabel( 'Out-of-Plane [km]' );
    set( gca , 'FontName' , 'Helvetica' );
    set( [ hXLabel , hYLabel ] , 'FontName' , 'AvantGarde' , ...
         'FontSize' , 10 );
    set( gca , 'TickLength' , [0.01 0.01] );
    set( gcf , 'units' , 'inches' , 'NumberTitle' , 'off' );
    set( gcf , 'position' , [0,0.9,6,4.75] ); 
    set( gcf, 'PaperPositionMode' , 'auto' );     
    saveas(gcf, 'fig3', 'png')

figure(4);
    plot( rho(:,2) , rho(:,3) );
    hold all
    plot( rho(idx,2) , rho(idx,3) );
    plot( 0 , 0 , 'k.' , 'MarkerSize' , 21 );     
    grid on
    hXLabel = xlabel( 'Along-Track [km]' );
    hYLabel = ylabel( 'Out-of-Plane [km]' );
    set( gca , 'FontName' , 'Helvetica' );
    set( [ hXLabel , hYLabel ] , 'FontName' , 'AvantGarde' , ...
         'FontSize' , 10 );
    set( gca , 'TickLength' , [0.01 0.01] );
    set( gcf , 'units' , 'inches' , 'NumberTitle' , 'off' );
    set( gcf , 'position' , [6,0.9,6,4.75] ); 
    set( gcf, 'PaperPositionMode' , 'auto' );    
    saveas(gcf, 'fig4', 'png')
   