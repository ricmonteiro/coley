
import './App.css';
import LoginScreen from './screens/LoginScreen';
import SelectRoles from './screens/SelectRoleScreen';
import { Routes, Route } from 'react-router-dom';

function App() {
  return (
    <div>
      <Routes>
        <Route path="/" element={<LoginScreen />} />
        <Route path="/select_role" element={<SelectRoles />} />
      </Routes>
    </div>
  )
}

export default App;

//        <Route path="/dashboard" element={<DashboardPage />} />
