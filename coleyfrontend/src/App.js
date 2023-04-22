
import './App.css';
import Dashboard from './screens/MainDashboard';
import LoginScreen from './screens/LoginScreen';
import SelectRoles from './screens/SelectRoleScreen';
import MainDashboard from './screens/MainDashboard';
import CreateUser from './screens/CreateUserScreen';
import { Routes, Route } from 'react-router-dom';

function App() {
  return (
    <div>
      <Routes>
        <Route path="/" element={<LoginScreen />} />
        <Route path="/select_role" element={<SelectRoles />} />
        <Route path="/dashboard" element={<MainDashboard />}/>
        <Route path="/register_new_user" element={<CreateUser/>}/>
      </Routes>
    </div>
  )
}

export default App;

//        <Route path="/dashboard" element={<DashboardPage />} />
