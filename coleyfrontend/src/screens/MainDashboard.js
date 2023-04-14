import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';


const MainDashboard = () => {
  const location = useLocation();
  const selectedRole = location.state && location.state.selectedRole;
  const navigate = useNavigate();

  const handleBack = () => {
    navigate('/');
  }

  return (
    <div className='dash'>
      <h1>MainDashboard</h1>
      {selectedRole && <p>Role: {selectedRole}</p>}
      <button className='role-selection-buttons button' style={{ backgroundColor: "black" }} onClick={handleBack}>Logout</button>

    </div>
  );
};

export default MainDashboard;