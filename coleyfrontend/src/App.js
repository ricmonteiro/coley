
import './App.css';
import LoginScreen from './screens/LoginScreen';
import SelectRoles from './screens/SelectRoleScreen';
import MainDashboard from './screens/MainDashboard';
import CreateUser from './screens/CreateUserScreen';
import CreateSample from './screens/CreateSampleScreen';
import CreatePatient from './screens/CreatePatientScreen';
/**import CreateCut from './screens/CreateCutScreen';**/
import CreateAnalysis from './screens/CreateAnalysisScreen';
import { Routes, Route } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import SamplesAndCuts from './screens/SamplesAndCutsScreen';
import GetResults from './screens/GetResultsScreen';


function App() {
  return (
    <div style={{backgroundImage:"url(/bggif.gif)", backgroundPosition:"50% -4%", backgroundRepeat:"no-repeat", backgroundSize:"1100px 600px"}}>
      <Routes>

        <Route path="/" element={<LoginScreen />} />
        <Route path="/select_role" element={<SelectRoles />} />
        <Route path="/dashboard" element={<MainDashboard />} />
        <Route path="/new_user" element={<CreateUser/>} />
        <Route path="/new_sample" element={<CreateSample/>} />
        <Route path="/new_patient" element={<CreatePatient/>} />
        <Route path="/new_analysis" element={<CreateAnalysis/>} />
        <Route path="/samples_and_cuts" element={<SamplesAndCuts/>} />
        <Route path="/get_results" element={<GetResults/>} />

      </Routes>
    </div>
  )
}

export default App;