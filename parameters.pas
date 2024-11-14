unit parameters;

interface

// computation
var
TimeTick: double;

var
SimTime:double;
SimTickNumber:integer;
SimTotalDuration_ms: double; //ms
Stop_simulations: boolean;

// tsting voltage clamp
Apply_voltage_clamp:boolean;
V_begin, V_end,  V_step, V_hold, V_pulse,
//V_TSampling, , V_Trecord,
V_Tbegin, V_Tend: double;




// output
SimOutputSampling_ms: double;
SimOutputSampling_ticks: integer;
SimOutputTick_counter: integer;


// ticks for integration of slow diffusion, SERCA, and check trends
var
  NTicks_Diffu2D_Ring_FSR,
  NTicks_Diffu_FSR_to_JSR,
  NTicks_Diffu_Ring_to_Core_FSR,
  NTicks_Diffu_Ring_to_Core_Cyt,
  NTicks_SERCA
  : integer;

var
  iTicks_Diffu2D_Ring_fSR,
  iTicks_Diffu_FSR_to_JSR,
  iTicks_Diffu_Ring_to_Core_FSR,
  iTicks_Diffu_Ring_to_Core_Cyt,
  iTicks_SERCA
//  iTicks_test_trends
  : integer;
//Check_trends_boo: boolean;

// Cell geometry, compartments, grid, and voxels
const
L_cell_approx_mkm = 54; // μm
R_cell_approx_mkm  = 3.5; // μm
GridSz_mkm = 0.12; // μm

// submembrane space depth
Sub_depth_mkm = 0.02; // μm: Submembrane voxel depth

// ring
VoxelRing_GridSizeX =3;// ring voxel size X in grid units
VoxelRing_GridSizeY =3;// ring voxel size Y in grid units
VoxelRing_depth_mkm = 0.8; // μm: Ring voxel depth

// Cytosol and FSR fractions
V_cyt_part = 0.46; // Fractional volume of cytosol
V_fSR_part = 0.035; // Fractional volume of FSR

// Object that keeps property of a voxel
 type
  VoxelType = record
              SzX, SzY: integer; // voxel size in Grid units
              NvoxX, NvoxY: integer; //  N of voxels in X and Y for the entire cell
              V1_mkm3, // volume in mkm^3
              V1_liters, // volume in liters
              dX_mkm, // distance between neighboring voxel centers in x
              dY_mkm // distance between neighboring voxel centers in y
              :double;
            end;
var
VoxelSub, VoxelRing:VoxelType;// Note: both FSR and cytosol reside inside Voxel ring

// calculated parameters for cell geometry
var
L_cross_perimeter_approx_mkm: double;
R_core_mkm: double;
xGridLen,
yGridLen,
Num_Sub_voxels,
Num_Ring_voxels
: integer;

// cell size (exact)
L_cell_mkm,
L_cross_mkm,
R_cell_mkm,
S_cell_mkm2,

// Volumes
// V_in_attoliter (10^-18 liter) = 1e3*V_in_mkm^3
// V_in_femtoliter (10^-15 liter) = 1* V_in_mkm^3
// V_in_picoliter (10^-12 liter)=  1e-3*V_in_mkm3
// V_in_liter =  1e-15*V_in_mkm3

// cell volume
V_cell_mkm3,
// Total junctional SR volume
 V_JSR_total_mkm3,
//Volume of one junctional SR
// V_1JSR_mkm3,
// V_1JSR_liter, // used to calculate Ca release
// Total Submembrane volume
  V_sub_mkm3,
  V_sub_picoliter, // used to calculate dCa from IbCa and ICaT
// Total volume of cell core
  V_core_mkm3,
// Total volume of ring, i.e. between subspace and core
  V_ring_mkm3
: double;

// Calcium Release Unit (CRU): Ca release and JSR geometry
const
CaJSR_spark_activation = 0.3; // mM: critical JSR Ca loading to generate a spark (CRU can open)
Ispark_Termination =0.175; // pA: critical minimum Ispark triggering spark termination (CRU closes)
Iryr_at_1mM_CaJSR = 0.35; // pA: unitary RyR current at 1 mM delta Ca
RyR_to_RyR_distance_mkm = 0.03; // μm: RyR crystal grid size in JSR
JSR_depth_mkm = 0.06; // μm: JSR depth
kom=0.117; // ms^-1 RyR closing rate
Ispark_inactivation_tau_ms = 1/kom; //  = 8.54700854701 ms


var
Ispark_activation_tau_ms, // 40; // 80 !!!; // ms: Time constant of spark activation (a)
Ispark_activation_tau_in_timeticks:double;
Ispark_inactivation_tau_in_timeticks:double;
CRU_Casens, // = 0.00015; // mM: sensitivity of Ca release to Casub
CRU_ProbConst, // =0.00027; // 0.0003 ms-1: CRU open probability rate at Casub=CRU_Casens
ScalingPobConst,
Ispark_Termination_scale,
CRU_ProbPower // = 3; //: Cooperativity of CRU activation by Casub
: double;

//  this reflects lower interaction profiles for smaller CRUs
// becuase Ca release is closer to the border that drains Ca to the cytoplasm
BorderEffect: array[1..500] of double;

// Interface parameters
var
TotalNRyRs,
MaxNRyRsInCRU, // maximal # of RyRs in CRU
MinNRyRsInCRU, // minimal # of RyRs in CRU
nCRUs // total # of CRUs
: integer;

CRUSizeDistr: array of integer;

// CRU object that keeps all properties of each CRU
Type
voxel_in_CRU_type = record
       xv, yv: integer; // voxel's xy coordinates on the grid
       nRyRv: integer; // N of RyRs in the voxel  (up to 16)
end;

type
CRU_type = record
       // geometry
         x,y: integer;    // grid coordinates of the CRU Ca sensor
         xe,ye: double;    // exact grid coordinates of the CRU Ca sensor
         ForceX,ForceY: double; // repulsion force
         dxdt, dydt: double; // velocity
         dx2dt, dy2dt: double; // acceleration
         CajSR1:double;   // jSR [Ca]
         JSR1_volume_mkm3: double;
         JSR1_volume_liter: double;
         Dyadic_volume_liter: double;
         NRyR: integer; // # of RyRs in the CRU
         NVoxels: integer; //# of voxels in the CRUs
         voxels: array of voxel_in_CRU_type;
     // release function
         Open:boolean;     // CRU is open
         TimeOpen:integer;   // time in open states in time ticks
         TimeClosed:integer; // time in closed state in time ticks
         activation: double; // CRU activation kinetics (runtime)
// CRU inactivation kinetics (runtime) reflecting RyR closing
// that is only time dependent via kom in Stern model
// It is important to have inactivation to reach a termination threshold
// defined in terms of Iryr, otherwise Ispark will be always higher/larger than
// the threshold
         inactivation: double;
         Ispark: double;   // CRU Ca2+ current (runtime)
         Ispark_before: double;   // CRU Ca2+ current before current tick (to test tendency)
         Ispark_at_1mM_CaJSR1: double; // const for this CRU
//         Ispark_Termination1: double;
         to1: double;   // to find SR Ca shift for this CRU size
      // Ca buffering in JSR
         fCQ: double;     // fractional ocupancy of calsequestrin in jSR
     // ICaL function
         CRUgCav12, CRUgCav13: double; // conductances for Cav1.2 and Cav1.3
         fCa:double; // local Ca-dependent inactivation of  Cav1.2 and Cav1.3 in each CRU
    // diffusion connection with FSR
         FCC_FSRtoJSR1: double;
         Volume_ratio_jSR_to_FSR_in_VoxelRing1: double;
     end;

var
ArCRU: array of CRU_type; // array that keeps info about all CRUs
NvoxelsInAllCRUs: integer;
MaxVoxelsN, MinVoxelsN: integer;


// set type of 2D arrays for local [Ca] dynamics
Type Ar2Dtype= array of array of double;

var
       // 2D arrays for local [Ca] dynamics
       // subspace
        ArSubCyt,
        ArSubfCM, // Fractional occupancy of calmodulin by Ca2+  in subspace
        // ring (between subspace and core)
        ArRingCyt,
        ArRingFSR,
        ArRingfCM, // Fractional occupancy of calmodulin by Ca2  in myoplasm
        // 2D arrays to add/remove Ca each tick in each voxel
        ArSubCyt_dCa,
        ArRingCyt_dCa,
        ArRingfSR_dCa
       :Ar2Dtype;

// Cell Core variables
       CoreFSR,
       CoreCyt,
       CoreCyt_dCa,
       CoreFSR_dCa,
       CorefCM
        :double;


//Ca buffering
const
kbCM = 0.542; // ms-1: Ca dissociation constant for calmodulin
kfCM = 227.7; // mM-1· ms-1: Ca association constant for calmodulin
kbCQ = 0.445; // ms-1: Ca2+ dissociation constant for calsequestrin
kfCQ = 0.534; // mM-1· ms-1: Ca association constant for calsequestrin
CQtot = 30; // mM; //: Total calsequestrin concentration
CM_total = 0.045; // mM: Total calmodulin concentration

// Ca diffusion
const
DCyt_mkm2_per_ms = 0.35;
DFSR_mkm2_per_ms = 0.06;
Tau_FSR_JSR_ML_model = 40; // 11.62; // ms

// voxel ratios used in diffusion formulations:
var
  Volume_ratio_VoxelSub_to_VoxelRing,
  Volume_ratio_jSR_to_FSR_in_VoxelRing,
  Volume_ratio_fSR_to_cyt,
  Volume_ratio_VoxelRing_to_Core
 : double;

// relative change of Ca via diffusion each time update
var
 // in layers
       FCC_CytSubX,
       FCC_CytSubY,
       FCC_CytRingX,
       FCC_CytRingY,
       FCC_FSRRingX,
       FCC_FSRRingY,
// radial diffusion
       FCC_CytRingToCore,
       FCC_FSRRingToCore,
       FCC_CytSubToRing,
// FSR to JSR
       FCC_FSRtoJSR
       : double;

//SERCA pumping
Const
Kmf = 0.000246; // mM: the cytosolic side Kd of SR Ca pump
Kmr = 1.7; // mM: the lumenal side Kd of SR Ca pump
H_SERCA = 1.787; //: cooperativity of SR Ca pump
//Pup = 0.014; // mM/ms: Maximal rate of  Ca uptake by SR Ca pump ***

// We use tabulated values for SERCA pumping to accelerate computation
// 1 million tabulated values for a good resolution in a wide dynamic range
const SERCA_tab_max =  1000*1000;
var
// 1 nM resolution in cytoplasm from 1 nM to 1 mM
SERCA_i_tab: array[1..SERCA_tab_max] of double;
// 10 nM resolution in FSR from 10 nM to 10 mM
SERCA_SR_tab: array[1..SERCA_tab_max] of double;


// ELECTROPHYSIOLOGY
//Basic constants
const
FaradayConst = 96485.3365;  // C/mol
FaradayConst_x_2 = FaradayConst*2; // to calculate 1 Mol Ca2+  (double charge)
Temperature=310.15; // K      310.15oK = 37oC
Rconst=8.3144;      // J · M^-1 · K^-1
// RT/F = 1000*8.3144*310.15/96485.336 =  26.726456754 mV
RTdivF=1000*Rconst* Temperature  / FaradayConst; // in mV

//Specific membrane capacitance was calculated from 2002 Kurata model
// for its 32 pF cylinder cell of 70 μm in length and 4 μm radius
// S_Kurata_cell = 70*2*pi*4+ 2*pi*4*4 =  1,859.82285093 μm^2
// C_spec = 32 / 1,859.82285093 = 0.0172059397937 pF/μm^2
C_pF_per_mkm2 = 0.0172059397937;

// Units used in electrophysiology part:
{mM = mmol/L: concentration,
ms: time,
mV: voltage,
pA: electric current,
pF: electric capacitance,
nS: electric conductance
}

const
// Fixed ion concentrations
Cao=2; // mM: Extracellular Ca concentration
Ko=5.4; // mM: Extracellular K concentration
Nao=140; // mM: Extracellular Na concentration
Ki=140; // mM: Intracellular K concentration
Nai=10;  // mM: Intracellular Na concentration

// parameters to simulate beta adrenergic response ***
var
bAR_stimulation_apply: boolean;
bAR_onset,bAR_percent: double;
Pup, // mM/ms: Maximal rate of  Ca uptake by SR Ca pump ***
gCaL,  // nS/pF: Conductance of ICaL ***
frac12_gCaL, // fraction of Cav1.2 in gCaL
frac13_gCaL, // fraction of Cav1.3 in gCaL
V_Ih12,  //  half activation voltage of If; mV   ***
gKr      // nS/pF: Conductance of delayed rectifier K current rapid component ***
:double;

const
// Parameters for membrane currents
// parameters marked *** are set differently for basal and beta adrenergic stimulation
ECaL = 45; // mV: Apparent reversal potential of ICaL
//gCaL = 0.464; // nS/pF: Conductance of ICaL ***
KmfCa = 0.03; // mM: Dissociation constant of Ca2+ -dependent ICaL inactivation
//betafCa = 60; // mM-1 · ms-1:  Ca2+ association rate constant for ICaL.
alfafCa = 0.021;// ms-1: Ca2+ dissociation rate constant for ICaL
// Note in Kurata model    KmfCa =  alfafCa/betafCa
// Thus, KmfCa, alfafCa,  betafCa are not independent parameters
k_TauFL = 0.5; //: Scaling factor for tau_fL
ECaT = 45; //: Apparent reversal potential of ICaT; mV
gCaT  = 0.1832; // nS/pF: Conductance of ICaT
gh  = 0.105; // nS/pF: Conductance of If
//V_Ih12 = -64; //: half activation voltage of If; mV   ***
//gKr = 0.05679781; // nS/pF: Conductance of delayed rectifier K current rapid component ***
k_IKr_Tau = 0.3; //: scaling factor for tau_paF and tau_paS
gKs = 0.0259; // nS/pF: Conductance of delayed rectifier K current slow component
gto = 0.252; // nS/pF: Conductance of 4-aminopyridine sensitive transient K+ current
gsus = 0.02; // nS/pF: Conductance of 4-aminopyridine sensitive sustained K+ current
INaKmax = 1.44; // pA/pF: Maximum Na+/K+ pump current
KmKp = 1.4; // mM: Half-maximal Ko for INaK.
KmNap = 14; // mM: Half-maximal Nai for INaK.
gbCa = 0.003; // nS/pF: Conductance of background Ca2+ current;
kNCX = 48.75; // pA/pF: Maximumal amplitude of INCX
// Dissociation constants for NCX
K1ni = 395.3; // mM: intracellular Na binding to first site on NCX
K2ni = 2.289; // mM: intracellular Na binding to second site on NCX
K3ni = 26.44; // mM: intracellular Na binding to third site on NCX
K1no = 1628; // mM: extracellular Na binding to first site on NCX
K2no = 561.4; // mM: extracellular Na binding to second site on NCX
K3no = 4.663; // mM: extracellular Na binding to third site on NCX
Kci = 0.0207; // mM: intracellular Ca binding to NCX transporter
Kco = 3.663; // mM:  extracellular Ca binding to NCX transporter
Kcni = 26.44; // mM: intracellular Na and Ca2+ simultaneous binding to NCX
// NCX fractional charge movement
Qci= 0.1369; //: intracellular Ca occlusion reaction of NCX
Qco=0; //: extracellular Ca occlusion reaction of NCX
Qn= 0.4315; //: Na occlusion reactions of NCX


//Model variables for electrophysiology
var
EK, //   Equilibrium potential for K+, mV
EKs,//   Reversal potential of IKs, mV
ENa, //   Equilibrium potential for Na+, mV
Vm,     // Membrane potential, mV
Im,     // Net membrane current, pA
dVdt,   // dV/dt, mV/ms
Cm  // membrane  capacitance
:double;

//  Gating variables for membrane currents:
dL12,     // Activation gating variable for Cav1.2 ICaL
dL13,     // Activation gating variable for Cav1.3 ICaL

fL12,     // Voltage-dependent inactivation gating variable for Cav1.2 ICaL
fL13,     // Voltage-dependent inactivation gating variable for Cav1.3 ICaL

dT,     // Activation gating variable for ICaT
fT,     // Inactivation gating variable for ICaT
n,      // Activation gating variable for IKs
paF,    // Fast activation gating variable for IKr
paS,    // Slow activation gating variable for IKr
pi_,    // Inactivation gating variable for IKr
q,      // Inactivation gating variable for Ito
r,      // Activation gating variable for Ito and Isus
y:      // Activation gating variable for Ih
double;

// Specific whole-cell membrane ion currents, pA
var

ICaL12,   //  Cav1.2 L-type Ca2+  current
ICaL13,   //  Cav1.3 L-type Ca2+  current
ICaL,       //  total ICaL =  Cav1.3 + Cav1.2

I_f,     //  Hyperpolarization-activated "funny" current: I_f = IhNa + IhK:
IKr,    //  Rapid component of the delayed rectifier K+ current
INCX,   //  Na+/Ca2+ exchanger current
ICaT,   //  T-type Ca2+  current
IKs,    //  Slow component of the delayed rectifier K+ current
INaK,   //  Na+-K+ pump current
Isus,   //  Sustained component of the 4-AP-sensitive current
Ito,    //  Transient component of the 4-AP-sensitive current
IbCa,    //  Background Ca2+ current
Iext
: double;

// parameters to compute local currents
INCX_max_1_voxel // max NCX current via 1 grid unit of cell membrane;
: double;

//parameters to optimize computation
kNaK: double;

// Initial values: //////////////////////////////////
var
Initial_Ca_Cyt, //  Ca concentration in cytosol
Initial_Ca_fSR,// Ca concentration of free SR
Initial_Ca_jSR, // Ca concentration in junctional SR
Initial_fCM_cyt,//Fractional occupancy of calmodulin by Ca in myoplasm
Initial_fCM_sub, //Fractional occupancy of calmodulin by Ca in submembrane space
Initial_fCQ_jsr, //Fractional occupancy of calsequestrin by Ca in junctional SR
Initial_fCa // Ca dependent ICaL inactivation
: double;

implementation


end.
