'use client';

import { useEffect, useState } from 'react';
import { initializeApp } from 'firebase/app';
import { getDatabase, ref, onValue, set } from 'firebase/database';
import {
  Wifi,
  WifiOff,
  Gamepad2,
  Zap,
  ArrowUp,
  ArrowDown,
  ArrowLeft,
  ArrowRight,
  Square,
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';

const firebaseConfig = {
  apiKey: 'REPLACE_WITH_WEB_API_KEY',
  authDomain: 'lab1-f7c43.firebaseapp.com',
  databaseURL: 'https://lab1-f7c43-default-rtdb.firebaseio.com/',
  projectId: 'lab1-f7c43',
  storageBucket: 'lab1-f7c43.appspot.com',
  messagingSenderId: 'REPLACE_WITH_SENDER_ID',
  appId: 'REPLACE_WITH_APP_ID',
};

let app: any;
let database: any;

try {
  app = initializeApp(firebaseConfig);
  database = getDatabase(app);
} catch (error) {
  console.error('Firebase initialization error:', error);
}

interface TelemetryData {
  F: number;
  L: number;
  R: number;
  D: number;
  B: number;
}

interface LaneStatus {
  detected: boolean;
  offset: number;
  timestamp?: number;
}

interface EyeMonitorData {
  state: 'UNKNOWN' | 'AWAKE' | 'DROWSY';
  p_open: number;
  p_closed: number;
}

const EYE_MONITOR_THRESHOLD = 0.2;

export function RCCarDashboard() {
  const [connected, setConnected] = useState(false);
  const [telemetry, setTelemetry] = useState<TelemetryData>({
    F: 0,
    L: 0,
    R: 0,
    D: 0,
    B: 0,
  });
  const [mode, setMode] = useState<'MANUAL' | 'AUTO'>('MANUAL');
  const [initialLoad, setInitialLoad] = useState(true);
  const [laneStatus, setLaneStatus] = useState<LaneStatus>({
    detected: false,
    offset: 0,
  });
  const [eyeMonitor, setEyeMonitor] = useState<EyeMonitorData>({
    state: 'UNKNOWN',
    p_open: 0,
    p_closed: 0,
  });

  // Listen for telemetry data
  useEffect(() => {
    if (!database) return;

    const telemetryRef = ref(database, 'car_telemetry/latest');
    const unsubscribe = onValue(
      telemetryRef,
      (snapshot) => {
        if (snapshot.exists()) {
          const data = snapshot.val();
          setTelemetry(data);
          setConnected(true);
        }
        setInitialLoad(false);
      },
      (error) => {
        console.error('Firebase error:', error);
        setConnected(false);
        setInitialLoad(false);
      }
    );

    return () => unsubscribe();
  }, []);

  // Listen for mode changes
  useEffect(() => {
    if (!database) return;

    const modeRef = ref(database, 'car_control/mode');
    const unsubscribe = onValue(
      modeRef,
      (snapshot) => {
        if (snapshot.exists()) {
          const data = snapshot.val();
          if (data === 'MANUAL' || data === 'AUTO') {
            setMode(data);
          }
        }
      },
      (error) => {
        console.error('Error listening to mode:', error);
      }
    );

    return () => unsubscribe();
  }, []);

  // Listen for lane status
  useEffect(() => {
    if (!database) return;

    const laneRef = ref(database, 'lane_status');
    const unsubscribe = onValue(
      laneRef,
      (snapshot) => {
        if (snapshot.exists()) {
          const data = snapshot.val();
          setLaneStatus({
            detected: data.detected || false,
            offset: data.offset || 0,
            timestamp: data.timestamp,
          });
        }
      },
      (error) => {
        console.error('Error listening to lane status:', error);
      }
    );

    return () => unsubscribe();
  }, []);

  // Listen for eye monitor data
  useEffect(() => {
    if (!database) return;

    const eyeRef = ref(database, 'eye_monitor');
    const unsubscribe = onValue(
      eyeRef,
      (snapshot) => {
        if (snapshot.exists()) {
          const data = snapshot.val();
          setEyeMonitor({
            state: data.state || 'UNKNOWN',
            p_open: data.p_open || 0,
            p_closed: data.p_closed || 0,
          });
        }
      },
      (error) => {
        console.error('Error listening to eye monitor:', error);
      }
    );

    return () => unsubscribe();
  }, []);

  const handleModeChange = (newMode: 'MANUAL' | 'AUTO') => {
    if (!database) return;
    setMode(newMode);
    set(ref(database, 'car_control/mode'), newMode).catch((error) => {
      console.error('Error setting mode:', error);
    });
  };

  const handleCommand = (command: string) => {
    if (!database || mode !== 'MANUAL') return;
    set(ref(database, 'car_control/command'), command).catch((error) => {
      console.error('Error sending command:', error);
    });
  };

  const getDoorStatus = () => telemetry.D === 1;
  const getSeatbeltStatus = () => telemetry.B === 1;

  const getEyeStateColor = (state: string) => {
    switch (state) {
      case 'AWAKE':
        return 'bg-green-900 text-green-200 border-green-700';
      case 'DROWSY':
        return 'bg-red-900 text-red-200 border-red-700';
      default:
        return 'bg-slate-800 text-slate-400 border-slate-700';
    }
  };

  const isAmbiguousEyeState = () => {
    return Math.abs(eyeMonitor.p_open - eyeMonitor.p_closed) < EYE_MONITOR_THRESHOLD;
  };

  return (
    <div className="min-h-screen bg-slate-950 text-white p-6">
      {/* Header */}
      <div className="mb-8 flex items-center justify-between">
        <h1 className="text-3xl font-bold text-balance">RC Car Dashboard</h1>
        <div className="flex items-center gap-2">
          {connected ? (
            <>
              <Wifi className="h-5 w-5 text-green-500" />
              <span className="text-green-500 font-semibold">Connected</span>
            </>
          ) : (
            <>
              <WifiOff className="h-5 w-5 text-red-500" />
              <span className="text-red-500 font-semibold">
                {initialLoad ? 'Connecting...' : 'Disconnected'}
              </span>
            </>
          )}
        </div>
      </div>

      {/* Telemetry Section */}
      <div className="mb-8">
        <h2 className="text-lg font-semibold mb-4 text-slate-300">Telemetry</h2>
        <div className="grid grid-cols-3 gap-4 mb-6">
          <Card className="bg-slate-900 border-slate-800 p-4">
            <div className="text-slate-400 text-sm mb-2">Front</div>
            <div className="text-3xl font-bold text-cyan-400">
              {telemetry.F}
              <span className="text-lg text-slate-400 ml-2">cm</span>
            </div>
          </Card>
          <Card className="bg-slate-900 border-slate-800 p-4">
            <div className="text-slate-400 text-sm mb-2">Left</div>
            <div className="text-3xl font-bold text-cyan-400">
              {telemetry.L}
              <span className="text-lg text-slate-400 ml-2">cm</span>
            </div>
          </Card>
          <Card className="bg-slate-900 border-slate-800 p-4">
            <div className="text-slate-400 text-sm mb-2">Right</div>
            <div className="text-3xl font-bold text-cyan-400">
              {telemetry.R}
              <span className="text-lg text-slate-400 ml-2">cm</span>
            </div>
          </Card>
        </div>

        {/* Status Badges */}
        <div className="flex gap-4">
          <Badge
            className={
              getDoorStatus()
                ? 'bg-green-900 text-green-200 border-green-700'
                : 'bg-red-900 text-red-200 border-red-700'
            }
            variant="outline"
          >
            Door: {getDoorStatus() ? 'CLOSED' : 'OPEN'}
          </Badge>
          <Badge
            className={
              getSeatbeltStatus()
                ? 'bg-green-900 text-green-200 border-green-700'
                : 'bg-red-900 text-red-200 border-red-700'
            }
            variant="outline"
          >
            Seatbelt: {getSeatbeltStatus() ? 'OK' : 'MISSING'}
          </Badge>
        </div>
      </div>

      {/* Lane Detection Section */}
      <div className="mb-8">
        <h2 className="text-lg font-semibold mb-4 text-slate-300">Lane Detection</h2>
        <Card className="bg-slate-900 border-slate-800 p-6">
          <div className="flex items-center justify-between">
            <div className="flex-1">
              <div className="text-slate-400 text-sm mb-3">Status</div>
              <Badge
                className={
                  laneStatus.detected
                    ? 'bg-green-900 text-green-200 border-green-700 text-base py-2 px-4'
                    : 'bg-red-900 text-red-200 border-red-700 text-base py-2 px-4'
                }
                variant="outline"
              >
                {laneStatus.detected ? 'DETECTED' : 'NOT DETECTED'}
              </Badge>
            </div>
            <div className="flex-1 text-right">
              <div className="text-slate-400 text-sm mb-3">Offset from Center</div>
              <div className="text-3xl font-bold text-cyan-400">
                {laneStatus.offset}
                <span className="text-lg text-slate-400 ml-2">px</span>
              </div>
            </div>
          </div>
        </Card>
      </div>

      {/* Driver Eye Monitor Section */}
      <div className="mb-8">
        <h2 className="text-lg font-semibold mb-4 text-slate-300">Driver Eye Monitor</h2>

        {/* Alert Banner */}
        {isAmbiguousEyeState() && (
          <div className="mb-4 animate-pulse">
            <div className="bg-red-900 border-2 border-red-600 rounded p-4">
              <div className="text-red-200 font-bold text-center text-lg">
                ⚠️ WARNING: Ambiguous Eye State - Possible Drowsiness
              </div>
            </div>
          </div>
        )}

        <Card className="bg-slate-900 border-slate-800 p-6">
          <div className="grid grid-cols-3 gap-6">
            {/* State Display */}
            <div className="col-span-1 flex flex-col items-center justify-center">
              <div className="text-slate-400 text-sm mb-3">State</div>
              <Badge
                className={`${getEyeStateColor(eyeMonitor.state)} text-base py-2 px-4`}
                variant="outline"
              >
                {eyeMonitor.state}
              </Badge>
            </div>

            {/* Probability Open */}
            <div className="col-span-1">
              <div className="text-slate-400 text-sm mb-3">Eye Open Probability</div>
              <div className="text-3xl font-bold text-cyan-400">
                {(eyeMonitor.p_open * 100).toFixed(1)}
                <span className="text-lg text-slate-400 ml-2">%</span>
              </div>
            </div>

            {/* Probability Closed */}
            <div className="col-span-1">
              <div className="text-slate-400 text-sm mb-3">Eye Closed Probability</div>
              <div className="text-3xl font-bold text-cyan-400">
                {(eyeMonitor.p_closed * 100).toFixed(1)}
                <span className="text-lg text-slate-400 ml-2">%</span>
              </div>
            </div>
          </div>

          {/* Confidence Indicator */}
          <div className="mt-6 pt-6 border-t border-slate-800">
            <div className="text-slate-400 text-sm mb-3">Confidence Level</div>
            <div className="text-sm text-slate-400">
              Difference: {(Math.abs(eyeMonitor.p_open - eyeMonitor.p_closed) * 100).toFixed(1)}%
            </div>
            <div className="w-full bg-slate-800 rounded-full h-2 mt-2 overflow-hidden">
              <div
                className={`h-full transition-all ${
                  isAmbiguousEyeState() ? 'bg-red-600' : 'bg-green-600'
                }`}
                style={{
                  width: `${Math.abs(eyeMonitor.p_open - eyeMonitor.p_closed) * 100}%`,
                }}
              ></div>
            </div>
          </div>
        </Card>
      </div>

      {/* Mode Selection */}
      <div className="mb-8">
        <h2 className="text-lg font-semibold mb-4 text-slate-300">Mode</h2>
        <div className="flex gap-4">
          <Button
            onClick={() => handleModeChange('MANUAL')}
            className={`flex-1 py-6 text-lg font-semibold flex items-center justify-center gap-2 transition-colors ${
              mode === 'MANUAL'
                ? 'bg-blue-600 hover:bg-blue-700 text-white'
                : 'bg-slate-800 hover:bg-slate-700 text-slate-400'
            }`}
          >
            <Gamepad2 className="h-6 w-6" />
            MANUAL
          </Button>
          <Button
            onClick={() => handleModeChange('AUTO')}
            className={`flex-1 py-6 text-lg font-semibold flex items-center justify-center gap-2 transition-colors ${
              mode === 'AUTO'
                ? 'bg-yellow-600 hover:bg-yellow-700 text-white'
                : 'bg-slate-800 hover:bg-slate-700 text-slate-400'
            }`}
          >
            <Zap className="h-6 w-6" />
            AUTO
          </Button>
        </div>
      </div>

      {/* D-Pad Controls */}
      <div className="flex justify-center">
        <div className="w-64">
          <h2 className="text-lg font-semibold mb-4 text-slate-300 text-center">
            Controls
          </h2>
          {/* D-Pad Grid */}
          <div className="grid grid-cols-3 gap-2 mb-2">
            {/* Empty top-left */}
            <div></div>
            {/* Up Button */}
            <Button
              onClick={() => handleCommand('F')}
              disabled={mode !== 'MANUAL'}
              className="aspect-square bg-slate-800 hover:bg-slate-700 disabled:opacity-50 disabled:cursor-not-allowed text-white"
              size="lg"
            >
              <ArrowUp className="h-6 w-6" />
            </Button>
            {/* Empty top-right */}
            <div></div>

            {/* Left Button */}
            <Button
              onClick={() => handleCommand('L')}
              disabled={mode !== 'MANUAL'}
              className="aspect-square bg-slate-800 hover:bg-slate-700 disabled:opacity-50 disabled:cursor-not-allowed text-white"
              size="lg"
            >
              <ArrowLeft className="h-6 w-6" />
            </Button>

            {/* Stop Button (Center) */}
            <Button
              onClick={() => handleCommand('S')}
              disabled={mode !== 'MANUAL'}
              className="aspect-square bg-red-700 hover:bg-red-800 disabled:opacity-50 disabled:cursor-not-allowed text-white"
              size="lg"
            >
              <Square className="h-6 w-6" />
            </Button>

            {/* Right Button */}
            <Button
              onClick={() => handleCommand('R')}
              disabled={mode !== 'MANUAL'}
              className="aspect-square bg-slate-800 hover:bg-slate-700 disabled:opacity-50 disabled:cursor-not-allowed text-white"
              size="lg"
            >
              <ArrowRight className="h-6 w-6" />
            </Button>

            {/* Empty bottom-left */}
            <div></div>
            {/* Down Button */}
            <Button
              onClick={() => handleCommand('B')}
              disabled={mode !== 'MANUAL'}
              className="aspect-square bg-slate-800 hover:bg-slate-700 disabled:opacity-50 disabled:cursor-not-allowed text-white"
              size="lg"
            >
              <ArrowDown className="h-6 w-6" />
            </Button>
            {/* Empty bottom-right */}
            <div></div>
          </div>

          {/* Info Text */}
          {mode !== 'MANUAL' && (
            <p className="text-center text-sm text-slate-400 mt-4">
              Switch to MANUAL mode to control
            </p>
          )}
        </div>
      </div>
    </div>
  );
}
