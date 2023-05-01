
import './App.css';
import LoginScreen from './screens/LoginScreen';
import SelectRoles from './screens/SelectRoleScreen';
import MainDashboard from './screens/MainDashboard';
import CreateUser from './screens/CreateUserScreen';
import CreateSample from './screens/CreateSampleScreen';
import { Routes, Route } from 'react-router-dom';

function App() {
  return (
    <div>
      <Routes>
        <Route path="/" element={<LoginScreen />} />
        <Route path="/select_role" element={<SelectRoles />} />
        <Route path="/dashboard" element={<MainDashboard />}/>
        <Route path="/new_user" element={<CreateUser/>}/>
        <Route path="/new_sample" element={<CreateSample/>}/>
      </Routes>
    </div>
  )
}

export default App;