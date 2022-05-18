18May:
<p>Done: 1-3, 7, 8, 9, 12, 13, 16, 18, 21, 22</p>
<p>Re-do: 4-6, 10, 11, 14 (just for k exec commands), 15, 17-20</p>

<p>test using curl from temp pod: 10, 15, 17-19</p>
<p>17</p>
<p>k run tmp --restart=Never --rm -i --image=nginx:alpine -- curl ?clusterIP from 'k -n mars get pod -o wide'?</p>
<p>18</p>
<p>k -n mars run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 ?svcName:port OR clusterIP from 'k -n mars get all'?</p>
<p>19</p>
<p>k -n jupiter run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 ?svcName:port?</p>
