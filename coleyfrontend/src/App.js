
import './App.css';
import LoginScreen from './screens/LoginScreen';
import SelectRoles from './screens/SelectRoleScreen';
import MainDashboard from './screens/MainDashboard';
import CreateUser from './screens/CreateUserScreen';
import CreateSample from './screens/CreateSampleScreen';
import CreatePatient from './screens/CreatePatientScreen';
import { Routes, Route } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';

function App() {
  return (
    <div>
      <Routes>
        <Route path="/" element={<LoginScreen />} />
        <Route path="/select_role" element={<SelectRoles />} />
        <Route path="/dashboard" element={<MainDashboard />}/>
        <Route path="/new_user" element={<CreateUser/>}/>
        <Route path="/new_sample" element={<CreateSample/>}/>
        <Route path="/new_patient" element={<CreatePatient/>}/>
      </Routes>
    </div>
  )
}

export default App;